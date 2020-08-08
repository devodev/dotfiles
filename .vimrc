" Globals
filetype indent plugin on
syntax on
set background=dark
colorscheme solarized
set termguicolors
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set number
set notimeout ttimeout ttimeoutlen=200
set visualbell
set confirm
set laststatus=2
set ruler
set nostartofline

" Insert real tab on-demand with shift-TAB
inoremap <S-Tab> <C-V><Tab>

" Avoid mswin.vim making Ctrl-v act as paste
if has('win32')
  noremap <C-V> <C-V>
endif

" Highlight tab
:set listchars=tab:\│\ ,trail:-,extends:>,precedes:<,nbsp:+
:highlight SpecialKey guifg=#333333 guibg=#111111

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Show trailing whitepace and spaces before a tab:
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" It seems that vim does not handle
" sucessive calls of the match command gracefully.
" See here: https://vim.fandom.com/wiki/Highlight_unwanted_spaces
if version >= 702
  autocmd BufWinLeave * call clearmatches()
endif

" Language specific
autocmd FileType html setlocal ts=2 sts=2 sw=2
autocmd FileType ruby setlocal ts=2 sts=2 sw=2
autocmd FileType make setlocal noexpandtab

