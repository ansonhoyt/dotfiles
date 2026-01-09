-- Hammerspoon config
-- Dictation: hold Fn to record, release to transcribe and paste
-- See: https://github.com/ansonhoyt/dotfiles/issues/1

--------------------------------------------------------------------------------
-- Dictation module
--------------------------------------------------------------------------------

local dictate = {}

-- Config
dictate.script = os.getenv("HOME") .. "/bin/dictate"
dictate.sounds = {
  start = hs.sound.getByName("Tink"),
  stop = hs.sound.getByName("Pop"),
  error = hs.sound.getByName("Basso"),
}

-- State
dictate.recording = false
dictate.task = nil
dictate.menubar = nil

-- Menu bar icons
dictate.icons = {
  idle = "⎯",
  recording = "●",
  processing = "⋯",
}

-- Smart paste: app bundle ID -> keystroke
dictate.pasteKeys = {
  -- Add app-specific overrides here if needed
  -- ["com.mitchellh.ghostty"] = {{"cmd", "shift"}, "v"},
  ["default"] = {{"cmd"}, "v"},
}

-- Initialize menu bar
function dictate.initMenubar()
  if dictate.menubar then return end
  dictate.menubar = hs.menubar.new()
  dictate.setStatus("idle")
end

-- Update menu bar status
function dictate.setStatus(status)
  if dictate.menubar then
    dictate.menubar:setTitle(dictate.icons[status] or dictate.icons.idle)
  end
end

-- Get paste keystroke for current app
function dictate.getPasteKeys()
  local app = hs.application.frontmostApplication()
  local bundleID = app and app:bundleID() or "default"
  return dictate.pasteKeys[bundleID] or dictate.pasteKeys["default"]
end

-- Paste from clipboard
function dictate.paste()
  local keys = dictate.getPasteKeys()
  hs.eventtap.keyStroke(keys[1], keys[2])
end

-- Start recording
function dictate.startRecording()
  if dictate.recording then return end
  dictate.recording = true

  -- Play start sound
  if dictate.sounds.start then
    dictate.sounds.start:play()
  end

  dictate.setStatus("recording")

  -- Start dictate script (records until killed)
  dictate.task = hs.task.new(dictate.script, function(exitCode, stdOut, stdErr)
    dictate.handleResult(exitCode, stdOut, stdErr)
  end)
  dictate.task:start()
end

-- Stop recording
function dictate.stopRecording()
  if not dictate.recording then return end
  dictate.recording = false

  -- Play stop sound
  if dictate.sounds.stop then
    dictate.sounds.stop:play()
  end

  dictate.setStatus("processing")

  -- Send SIGTERM to stop recording (sox will exit, whisper runs)
  if dictate.task and dictate.task:isRunning() then
    dictate.task:terminate()
  end
end

-- Handle transcription result
function dictate.handleResult(exitCode, stdOut, stdErr)
  dictate.setStatus("idle")
  dictate.task = nil

  if exitCode == 0 and stdOut and #stdOut > 0 then
    -- Copy to clipboard and paste
    local text = stdOut:gsub("^%s*(.-)%s*$", "%1")  -- trim
    if #text > 0 then
      hs.pasteboard.setContents(text)
      dictate.paste()
    end
  elseif exitCode == 1 then
    -- Not ready
    if dictate.sounds.error then
      dictate.sounds.error:play()
    end
    hs.notify.new({
      title = "Dictation",
      informativeText = "Not ready. Run: dictate --setup",
    }):send()
  elseif exitCode ~= 0 then
    -- Other error (2=recording failed, 3=transcription failed)
    if dictate.sounds.error then
      dictate.sounds.error:play()
    end
  end
  -- exitCode 0 with empty output = too short, ignore silently
end

-- Fn key detection via eventtap
-- Fn key sets raw flag 0x800000 (bit 23)
local FN_FLAG = 0x800000

dictate.fnTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
  local flags = event:rawFlags()
  local fnDown = (flags & FN_FLAG) ~= 0

  if fnDown and not dictate.recording then
    dictate.startRecording()
  elseif not fnDown and dictate.recording then
    dictate.stopRecording()
  end

  return false  -- don't consume the event
end)

-- Start dictation module
function dictate.start()
  dictate.initMenubar()
  dictate.fnTap:start()
  print("Dictation: Fn-hold enabled")
end

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------

dictate.start()

-- Reload config shortcut: Cmd+Ctrl+R
hs.hotkey.bind({"cmd", "ctrl"}, "r", function()
  hs.reload()
end)

hs.notify.new({title = "Hammerspoon", informativeText = "Config loaded"}):send()
