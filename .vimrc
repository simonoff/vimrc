set nocompatible " Use Vim defaults (much better!)
set runtimepath=~/.neovim/,$VIMRUNTIME

syntax on

filetype off " required!

set rtp+=~/.neovim/bundle/Vundle.vim
call vundle#begin('~/.neovim/bundle')

" let Vundle manage Vundle
" required!
Plugin 'gmarik/Vundle.vim'

" Git
Plugin 'tpope/vim-fugitive'

" Web
Plugin 'pangloss/vim-javascript'
Plugin 'kchmck/vim-coffee-script'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'gorodinskiy/vim-coloresque'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'groenewege/vim-less'
Plugin 'tpope/vim-haml'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'digitaltoad/vim-jade'
Plugin 'wavded/vim-stylus'
Plugin 'slim-template/vim-slim'

" Ruby
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-endwise'
Plugin 'thoughtbot/vim-rspec'
Plugin 'ecomba/vim-ruby-refactoring'

" Node.js
Plugin 'moll/vim-node'

" Tools
Plugin 'tomtom/tcomment_vim'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'bling/vim-airline'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/syntastic'
Plugin 'editorconfig-vim'
Plugin 'Chiel92/vim-autoformat'
Plugin 'mattn/emmet-vim'
Plugin 'Raimondi/delimitMate'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-obsession'
Plugin 'dhruvasagar/vim-prosession'

" Theme
Plugin 'sickill/vim-monokai'
Plugin 'ciaranm/inkpot'
Plugin 'chriskempson/base16-vim'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()            " required
filetype plugin indent on    " required

set background=dark
colorscheme base16-monokai

set autoread " ReaLoad a file if was changed outside of Vim

set cc=80 " Highlight column at 80
set nowrap " Disable line wrapping.

" Use intelligent case while searching.
" If search string contains an upper case letter, disable ignorecase.
set smartcase
set incsearch " Incremental search
set hlsearch " Higlihts search results

" Identation
set autoindent " Copy indent from current line when starting a new line
set smarttab
set tabstop=2 " Number of space og a <Tab> character
set softtabstop=2
set shiftwidth=2 " Number of spaces use by autoindent
set expandtab " Pressing <Tab> puts spaces, and < and > for indenting uses psaces
set backspace=2

" Commands execute automatically on an event

" Rules to disable expandtab in makefiles and markdown files
autocmd FileType make set noexpandtab nosta
autocmd FileType md set expandtab nosta

" Ruby autocomplete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1 
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" Config Airline and status line
let g:smartusline_string_to_highlight = '(%n) %f '
set laststatus=2 " Seperate lines for state and mode
let g:airline_powerline_fonts=1 " Powerline simbols. Hermit font support it
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#syntastic#enabled=1
"let g:airline_left_sep='?' " If we use a font without support of powerline simbols
"let g:airline_right_sep=''
set showmode " Show current mode in the status line.
set showcmd " Show the command in the status line.

" turn off any existing search
if has("autocmd")
    au VimEnter * nohls
endif

" No icky toolbar, menu or scrollbars in the GUI
if has('gui')
    set guioptions-=m
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
end

" Show tabs and trailing whitespace visually
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        set list listchars=tab:»·,trail:·,extends:…,nbsp:‗
    else
        set list listchars=tab:»·,trail:·,extends:…
    endif
else
    if v:version >= 700
        set list listchars=tab:>-,trail:.,extends:>,nbsp:_
    else
        set list listchars=tab:>-,trail:.,extends:>
    endif
endif

set fillchars=fold:-

" Tabs and buffers
nmap   <F5>   :bprev<CR>
imap   <F5>   <Esc>:bprev<CR>
nmap   <F6>   :bnext<CR>
imap   <F6>   <Esc>:bnext<CR>
" tabs 
nmap <C-S-tab> :tabprevious<cr> 
nmap <C-tab> :tabnext<cr> 
map <C-S-tab> :tabprevious<cr> 
map <C-tab> :tabnext<cr> 
imap <C-S-tab> <ESC>:tabprevious<cr>i 
imap <C-tab> <ESC>:tabnext<cr>i 
nmap <C-t> :tabnew<cr> 
imap <C-t> <ESC>:tabnew<cr>

" Delete a buffer but keep layout
if has("eval")
    command! Kwbd enew|bw #
    nmap     <C-w>!   :Kwbd<CR>
endif

" Exit
imap <F12> <Esc>:qa<CR>
nmap <F12> :qa<CR>

" Enable/Disable line numbers
imap <F1> <Esc>:set<Space>nu!<CR>a
nmap <F1> :set<Space>nu!<CR>

" Saving
" Current buffer
imap <F2> <Esc>:w<CR>a
nmap <F2> :w<CR>
" All buffers
imap <F3> <Esc>:wa<CR>a
nmap <F3> :wa<CR>

" Enable/Disable showing search results
imap <F4> <Esc>:set<Space>hls!<CR>a
nmap <F4> :set<Space>hls!<CR>

" q: sucks
nmap q: :q

let g:prosession_default_session = 1
let g:prosession_tmux_title = 1
"source /usr/local/lib/python2.7/site-packages/powerline/bindings/vim/plugin/powerline.vim
"set laststatus=2
