set nocompatible

filetype on
syntax off

" use 4 character hard tabs
set ts=4
"set expandtab
"set smarttab
set shiftwidth=4
set softtabstop=4
set nowrap

set autoindent

set number

set mouse=a

set ignorecase
set smartcase
set incsearch

"set list                        " show invisible characters
"set listchars=tab:>·,trail:·    " but only show tabs and trailing whitespace

set wildignore=*.o
set wildmode=longest,list,full
set wildmenu

nnoremap gb :bn<cr>
nnoremap gB :bp<cr>

" ugh, I confuse tmux and vim window movement keys all the time, so unmap
" this annoying key sequence
nnoremap <C-w>o <NOP>

autocmd Filetype ruby setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype asm setlocal noexpandtab ts=8 sw=8 sts=8 noautoindent 
