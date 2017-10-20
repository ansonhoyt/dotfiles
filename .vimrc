set number " Display line number on left
set ruler  " Display the cursor position at bottom

syntax on                 " Enable syntax highlighting
filetype indent plugin on " Detect filetype, enable intelligent auto-indenting
set autoindent            " When no filetype-specific indenting, match current indent

set nobackup      " no backup files
set nowritebackup

set tabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start " Allow backspacing over autoindent, line breaks and start of insert action

set ignorecase " Case insensitive search
set smartcase  " ...except when using capital letters
set incsearch  " Incremental search
set hlsearch   " Highlight searches

" Strip trailing whitespace
" From http://rails-bestpractices.com/posts/60-remove-trailing-whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
