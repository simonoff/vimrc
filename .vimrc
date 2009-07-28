" encodding of config
scriptencoding utf-8
set encoding=utf-8

"-----------------------------------------------------------------------
" terminal setup
"-----------------------------------------------------------------------
"
" Extra terminal things
if ($TERM == "rxvt-unicode") && (&termencoding == "")
    set termencoding=utf-8
endif

if &term =~ "xterm" || &term == "rxvt-unicode"
    if exists('&t_SI')
        let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
        let &t_EI = "\<Esc>]12;grey80\x7"
    endif
endif

"-----------------------------------------------------------------------
" settings
"-----------------------------------------------------------------------

" set nocompatible with vi
" vi is suks!
set nocompatible

" Enable a nice big viminfo file
set viminfo='1000,f1,:1000,/1000

" Make backspace delete lots of things
set backspace=indent,eol,start

" Create backups
set backup

" Show us the command we're typing
set showcmd

" Highlight matching parens
set showmatch

" Search options: incremental search, do clever case things, highlight
" search
set incsearch
set ignorecase
set infercase
set hlsearch

" Show full tags when doing search completion
set showfulltag

" Speed up macros
set lazyredraw

" No annoying error noises
set noerrorbells
set visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Try to show at least three lines and two columns of context when
" scrolling
set scrolloff=3
set sidescrolloff=2

" Wrap on these
set whichwrap+=<,>,[,]

" Use the cool tab complete menu
set wildmenu
set wildignore=*.o,*~

" Allow edit buffers to be hidden
set hidden

" 1 height windows
set winminheight=1

" Enable syntax highlighting
syntax on

" By default, go for an indent of 4
set shiftwidth=4

" Do clever indent things. Don't make a # force column zero.
set autoindent
set smartindent
inoremap # X<BS>#

" Enable folds
set foldenable
set foldmethod=syntax

" Enable filetype settings
filetype on
filetype plugin on
filetype indent on

" set tab to 4 spaces
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
" backup files
set backup
set backupdir=.,~/tmp,~/
"c indent style
set cindent
set modeline
colors default
syntax on
set nowrap
set listchars+=precedes:<,extends:>
set sidescroll=5
set sidescrolloff=5
set backspace=indent,eol,start
set showmatch " проверка скобок
set history=1000 " увеличение истории команд
set undolevels=1000
set ttyfast
" Syntax when printing
set popt+=syntax:y

" Enable modelines only on secure vim versions
if (v:version == 603 && has("patch045")) || (v:version > 603)
    set modeline
else
    set nomodeline
endif

set ruler

" Set our fonts
set guifont=Monaco:h11

" Try to load a nice colourscheme
fun! LoadColourScheme(schemes)
    let l:schemes = a:schemes . ":"
    while l:schemes != ""
        let l:scheme = strpart(l:schemes, 0, stridx(l:schemes, ":"))
        let l:schemes = strpart(l:schemes, stridx(l:schemes, ":") + 1)
        try
            exec "colorscheme" l:scheme
            break
        catch
        endtry
    endwhile
endfun
 
if has('gui')
     call LoadColourScheme("inkpot")
else
     if &t_Co == 88 || &t_Co == 256
         call LoadColourScheme("inkpot:darkblue:elflord")
     else
         call LoadColourScheme("darkblue:elflord")
     endif
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


set statusline=%=%f\ \"%F\"\ %m%R\ [%4l(%3p%%):%3c-(0x%2B,\0%2b),%Y,%{&encoding}]

" Include $HOME in cdpath
let &cdpath=','.expand("$HOME").','.expand("$HOME").'/work'


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

"-----------------------------------------------------------------------
" completion
"-----------------------------------------------------------------------
set dictionary=/usr/share/dict/words
" php function completion
set tags+=/home/devil/php-tags/tags

"-----------------------------------------------------------------------
" autocmds
"-----------------------------------------------------------------------

" If we're in a wide window, enable line numbers.
fun! <SID>WindowWidth()
    if winwidth(0) > 90
        setlocal foldcolumn=0
        setlocal nonumber
    else
        setlocal nonumber
        setlocal foldcolumn=0
    endif
endfun

" Force active window to the top of the screen without losing its
" size.
fun! <SID>WindowToTop()
    let l:h=winheight(0)
    wincmd K
    execute "resize" l:h
endfun

" Force active window to the bottom of the screen without losing its
" size.
fun! <SID>WindowToBottom()
    let l:h=winheight(0)
    wincmd J
    execute "resize" l:h
endfun

" Update .*rc header
fun! <SID>UpdateRcHeader()
    let l:c=col(".")
    let l:l=line(".")
    1,10s-\(Most recent update:\).*-\="Most recent update: ".strftime("%c")-e
    call cursor(l:l, l:c)
endfun

" autocmds
augroup devil
   autocmd!

   " Automagic line numbers
   autocmd BufEnter * :call <SID>WindowWidth()

   " Update header in .vimrc and .bashrc before saving
   autocmd BufWritePre *vimrc  :call <SID>UpdateRcHeader()
   autocmd BufWritePre *bashrc :call <SID>UpdateRcHeader()

   " Always do a full syntax refresh
   autocmd BufEnter * syntax sync fromstart

   " For help files, move them to the top window and make <Return>
   " behave like <C-]> (jump to tag)
   autocmd FileType help :call <SID>WindowToTop()
   autocmd FileType help nmap <buffer> <Return> <C-]>

   " bash-completion ftdetects
   autocmd BufNewFile,BufRead /*/*bash*completion*/*
               \ if expand("<amatch>") !~# "ChangeLog" |
               \     let b:is_bash = 1 | set filetype=sh |
               \ endif
augroup END

augroup myfiletypes
    " Clear old autocmds in group
    autocmd!
    " autoindent with two spaces, always expand tabs
    autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
augroup END



" content creation
augroup content
    autocmd BufNewFile *.php 0put = '?>'|
                \ 0put = '// vim: set sw=4 sts=4 et foldmethod=syntax :'|
                \ 0put = '<?'|
                \ set sw=4 sts=4 et tw=80 |
                \ norm G
    autocmd BufNewFile *.php5 0put = '?>'|
                \ 0put = '// vim: set sw=4 sts=4 et foldmethod=syntax :'|
                \ 0put = '<?'|
                \ set sw=4 sts=4 et tw=80 |
                \ norm G
    autocmd BufNewFile *.rb 0put ='# vim: set sw=2 sts=2 et tw=80 :' |
                \ 0put ='#!/usr/bin/env ruby' | set sw=2 sts=2 et tw=80 |
                \ norm G
    autocmd BufNewFile *.sh 0put ='# vim: set sw=4 sts=4 et tw=80 :' |
                \ 0put ='#!/usr/bin/bash' | set sw=4 sts=4 et tw=80 |
                \ norm G

    autocmd BufNewFile *.pl 0put ='# vim: set sw=4 sts=4 et tw=80 :' |
                \ 0put ='#!/usr/bin/perl' | set sw=4 sts=4 et tw=80 |
                \ norm G

    autocmd BufNewFile *.hh 0put ='/* vim: set sw=4 sts=4 et foldmethod=syntax : */' |
                \ 1put ='' | call MakeIncludeGuards() |
                \ 5put ='#include \"config.h\"' |
                \ set sw=4 sts=4 et tw=80 | norm G

    autocmd BufNewFile *.cc 0put ='/* vim: set sw=4 sts=4 et foldmethod=syntax : */' |
                \ 1put ='' | 2put ='' | call setline(3, '#include "' .
                \ substitute(expand("%:t"), ".cc$", ".hh", "") . '"') |
                \ set sw=4 sts=4 et tw=80 | norm G
augroup END

autocmd VimEnter *
            \ if has('gui') |
            \        highlight ShowMarksHLl gui=bold guifg=#a0a0e0 guibg=#2e2e2e |
            \        highlight ShowMarksHLu gui=none guifg=#a0a0e0 guibg=#2e2e2e |
            \        highlight ShowMarksHLo gui=none guifg=#a0a0e0 guibg=#2e2e2e |
            \        highlight ShowMarksHLm gui=none guifg=#a0a0e0 guibg=#2e2e2e |
            \        highlight SignColumn   gui=none guifg=#f0f0f8 guibg=#2e2e2e |
            \    endif

" Settings for explorer.vim
let g:explHideFiles='^\.'

" Settings for netrw
let g:netrw_list_hide='^\.,\~$'

"-----------------------------------------------------------------------
" plugin / script / app settings
"-----------------------------------------------------------------------

" Perl specific options
let perl_include_pod=1
let perl_fold=1
let perl_fold_blocks=1

" Vim specific options
let g:vimsyntax_noerror=1

" c specific options
let g:c_gnu=1

" eruby options
au Syntax * hi link erubyRubyDelim Directory

" Settings for taglist.vim
let Tlist_Use_Right_Window=1
let Tlist_Auto_Open=0
let Tlist_Enable_Fold_Column=0
let Tlist_Compact_Format=1
let Tlist_WinWidth=28
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close = 1
nnoremap <silent> <F9> :Tlist<CR>

" Settings for showmarks.vim
if has("gui_running")
    let g:showmarks_enable=1
else
    let g:showmarks_enable=0
    let loaded_showmarks=1
endif

if has("autocmd")
    fun! <SID>FixShowmarksColours()
        if has('gui') 
            hi ShowMarksHLl gui=bold guifg=#a0a0e0 guibg=#2e2e2e 
            hi ShowMarksHLu gui=none guifg=#a0a0e0 guibg=#2e2e2e 
            hi ShowMarksHLo gui=none guifg=#a0a0e0 guibg=#2e2e2e 
            hi ShowMarksHLm gui=none guifg=#a0a0e0 guibg=#2e2e2e 
            hi SignColumn   gui=none guifg=#f0f0f8 guibg=#2e2e2e 
        endif
    endfun
    if v:version >= 700
        autocmd VimEnter,Syntax,ColorScheme * call <SID>FixShowmarksColours()
    else
        autocmd VimEnter,Syntax * call <SID>FixShowmarksColours()
    endif
endif

" Settings for explorer.vim
let g:explHideFiles='^\.'

" Settings for netrw
let g:netrw_list_hide='^\.,\~$'

" Settings for :TOhtml
let html_number_lines=1
let html_use_css=1
let use_xhtml=1

" cscope settings
if has('cscope') && filereadable("/usr/bin/cscope")
    set csto=0
    set cscopetag
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb

    let x = "sgctefd"
    while x != ""
        let y = strpart(x, 0, 1) | let x = strpart(x, 1)
        exec "nmap <C-j>" . y . " :cscope find " . y .
                    \ " <C-R>=expand(\"\<cword\>\")<CR><CR>"
        exec "nmap <C-j><C-j>" . y . " :scscope find " . y .
                    \ " <C-R>=expand(\"\<cword\>\")<CR><CR>"
    endwhile
    nmap <C-j>i      :cscope find i ^<C-R>=expand("<cword>")<CR><CR>
    nmap <C-j><C-j>i :scscope find i ^<C-R>=expand("<cword>")<CR><CR>
endif

"-----------------------------------------------------------------------
" final commands
"-----------------------------------------------------------------------

" turn off any existing search
if has("autocmd")
    au VimEnter * nohls
endif

" перекодировка 
let b:encindex=0
function! RotateEnc()
        let y = -1
        while y == -1
                let encstring = "#8bit-cp1251#8bit-cp866#utf-8#koi8-r#"
                let x = match(encstring,"#",b:encindex)
                let y = match(encstring,"#",x+1)
                let b:encindex = x+1
                if y == -1
                        let b:encindex = 0
                else
                        let str = strpart(encstring,x+1,y-x-1)
                        return ":set encoding=".str
                endif
        endwhile
endfunction

"-----------------------------------------------------------------------
" special less.sh and man modes
"-----------------------------------------------------------------------

fun! <SID>is_pager_mode()
    let l:ppidc = ""
    try
        if filereadable("/lib/libc.so.6")
            let l:ppid = libcallnr("/lib/libc.so.6", "getppid", "")
        elseif filereadable("/lib/libc.so.0")
            let l:ppid = libcallnr("/lib/libc.so.0", "getppid", "")
        else
            let l:ppid = ""
        endif
        let l:ppidc = system("ps -p " . l:ppid . " -o comm=")
        let l:ppidc = substitute(l:ppidc, "\\n", "", "g")
    catch
    endtry
    return l:ppidc ==# "less.sh" ||
                \ l:ppidc ==# "vimpager" ||
                \ l:ppidc ==# "manpager.sh" ||
                \ l:ppidc ==# "vimmanpager"
endfun

if <SID>is_pager_mode()
    " we're in vimpager / less.sh / man mode
    set laststatus=0
    set ruler
    set foldmethod=manual
    set foldlevel=99
    set nolist
endif

"-----------------------------------------------------------------------
" mappings
"-----------------------------------------------------------------------

" Find a buffer with the given number (ordering is such that the first
" entry shown in minibufexpl is 1, the second is 2 and so on). If
" there's already a window open for that buffer, switch to it. Otherwise
" switch the current window to use that buffer.
fun! <SID>SelectBuffer(wantedbufnum)
    let l:buflast = bufnr("$")
    let l:bufidx = 0
    let l:goodbufcount = 0
    while (l:bufidx < l:buflast)
        let l:bufidx = l:bufidx + 1
        if buflisted(l:bufidx)
            let l:bufname = bufname(l:bufidx)
            if (strlen(l:bufname)) &&
                        \ getbufvar(l:bufidx, "&modifiable") == 1 &&
                        \ l:bufname != '-MiniBufExplorer-'
                let l:goodbufcount = l:goodbufcount + 1
                if l:goodbufcount == a:wantedbufnum
                    let l:winnr = bufwinnr(l:bufidx)
                    if l:winnr > -1
                        execute l:winnr . "wincmd w"
                    else
                        execute "buffer " . l:bufidx
                    endif
                    break
                endif
            endif
        endif
    endwhile
endfun

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

" автодополнение фигурной скобки (так, как я люблю :)
imap {<CR> {<CR>}<Esc>O<Tab>

" автодополнение по Control+Space
imap <C-Space> <C-N>
" 'умный' Home
nmap <Home> ^
imap <Home> <Esc>I

" выход
imap <F12> <Esc>:qa<CR>
nmap <F12> :qa<CR>

" сохранение текущего буфера
imap <F2> <Esc>:w<CR>a
nmap <F2> :w<CR>

" сохранение всех буферов
imap <S-F2> <Esc>:wa<CR>a
nmap <S-F2> :wa<CR>
" no search 
nmap <silent> <F3> :silent nohlsearch<CR>
imap <silent> <F3> <C-o>:silent nohlsearch<CR>
" список буферов
imap <S-F4> <Esc>:buffers<CR>
nmap <S-F4> :buffers<CR>

" закрыть буфер
imap <C-F4> <Esc>:bd<CR>a
nmap <C-F4> :bd<CR>

" перекодировка
map <F8> :execute RotateEnc()<CR>

" окно ниже и развернуть
imap <C-F8> <Esc><C-W>j<C-W>_a
nmap <C-F8> <C-W>j<C-W>_

" окно выше и развернуть
imap <C-F7> <Esc><C-W>k<C-W>_a
nmap <C-F7> <C-W>k<C-W>_

" окно левее
imap <S-F7> <Esc><C-W>ha
nmap <S-F7> <C-W>h

" окно правее
imap <S-F8> <Esc><C-W>la
nmap <S-F8> <C-W>l

" следующая ошибка
imap <C-F10> <Esc>:cn<CR>i
nmap <C-F10> :cn<CR>

" предыдущая ошибка
imap <S-F10> <Esc>:cp<CR>i
nmap <S-F10> :cp<CR>

" вкл/выкл отображения номеров строк
imap <F1> <Esc>:set<Space>nu!<CR>a
nmap <F1> :set<Space>nu!<CR>

" вкл/выкл отображения найденных соответствий
imap <S-F1> <Esc>:set<Space>hls!<CR>a
nmap <S-F1> :set<Space>hls!<CR>

" q: sucks
nmap q: :q
