#!/usr/bin/env ruby
# frozen_string_literal: true

#
# PreToolUse hook: auto-allow WebFetch for GitHub URLs matching gems in Gemfile.
# Caches results per-project, expires in 1 hour, invalidates on Gemfile.lock changes.
# See: https://code.claude.com/docs/en/iam#additional-permission-control-with-hooks

require 'json'
require 'fileutils'
require 'benchmark'

elapsed = Benchmark.realtime do
  input = JSON.parse($stdin.read)
  exit 0 unless input['tool_name'] == 'WebFetch'

  @url = input.dig('tool_input', 'url')
  exit 0 unless @url&.match?(/github\.com|raw\.githubusercontent\.com/)

  gemfile = File.join(Dir.pwd, 'Gemfile')
  exit 0 unless File.exist?(gemfile)

  cache_file = File.join(Dir.pwd, '.claude', 'gem_github_urls.local.json')
  lockfile = File.join(Dir.pwd, 'Gemfile.lock')

  # Invalidate if Gemfile.lock changed or cache > 1 hour old
  cache_valid = File.exist?(cache_file) &&
                File.exist?(lockfile) &&
                File.mtime(cache_file) > File.mtime(lockfile) &&
                (Time.now - File.mtime(cache_file)) < 3600 # 1 hour

  if cache_valid
    @allowed_urls = JSON.parse(File.read(cache_file))
    @cached = true
  else
    require 'bundler'

    @allowed_urls = Bundler.load.specs.flat_map do |s|
      [s.homepage, s.metadata['source_code_uri'], s.metadata['homepage_uri']].compact
    end.select { |u| u.include?('github.com') }
       .map { |u| u[%r{https://github\.com/[^/]+/[^/]+}] } # extract base repo URL
       .compact
       .uniq

    FileUtils.mkdir_p(File.dirname(cache_file))
    File.write(cache_file, JSON.pretty_generate(@allowed_urls.sort))
    @cached = false
  end

  @matched_url = @allowed_urls.find { |gem_url| @url.start_with?(gem_url.chomp('/')) }
end

matched_url = @matched_url

if matched_url
  puts JSON.generate({
    permissionDecision: 'allow',
    matched_url: matched_url,
    cached: @cached,
    elapsed_ms: (elapsed * 1000).round(2)
  })
end
