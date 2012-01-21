call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set nocompatible
let mapleader=","

syntax on                       " Turn on syntax highlighting
filetype plugin on              " Enable filetype plugins
filetype indent on              " Let filetype plugins indent for me

" Edit/Reload vimrc
nmap <silent> <leader>ev :e $MYVIMRC<cr>
nmap <silent> <leader>sv :so $MYVIMRC<cr>
au! BufWritePost $MYVIMRC source $MYVIMRC


"""" Display
set background=dark                     " I use dark background
if has("gui_running")
    colorscheme inkpot
    set sessionoptions+=resize,winpos
    set lines=55 columns=130
    set guifont=Consolas:h9:cANSI
    set guitablabel=%N/\ %t\ %M         " tab labels show the filename without path(tail)

    set guioptions+=c                   " Use console dialogs instead of popups
    set guioptions+=a 
    set guioptions-=T                   " No toolbar
else
    colorscheme elflord
endif

""" Windows
if exists(":tab")                       " Try to move to other windows if changing buf
    set switchbuf=useopen,usetab
else                                    " Try other windows & tabs if available
    set switchbuf=useopen
endif

"""" Messages, Info, Status
set shortmess+=a                        " Use [+] [RO] [w] for modified, read-only, modified
set showcmd                             " Display what command is waiting for an operator
set ruler                               " Show pos below the win if there's no status line
set laststatus=2                        " Always show statusline, even if only 1 window
set report=0                            " Notify me whenever any lines have changed
set confirm                             " Y-N-C prompt if closing with unsaved changes
set vb t_vb=                            " Disable visual bell
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y[%{fugitive#statusline()}]
set statusline+=%=%{v:register}\ %c,%l/%L\ %P
set listchars=tab:>-,eol:$,trail:-,precedes:<,extends:>
"set lazyredraw                         " Don't repaint when scripts are running
set number                              " Show line numbering
set numberwidth=1                       " Use 1 col + 1 space for numbers
" set title
set titlestring=%F


"""" Editing
set hidden                              " Allow unchanged buffers to hide
set scrolloff=3                         " Keep 3 lines below and above the cursor
set backspace=indent,eol,start          " Backspace over anything! (Super backspace!)
set showmatch                           " Briefly jump to the previous matching paren
set matchtime=2                         " For .2 seconds
set formatoptions-=tc                   " I can format for myself, thank you very much
set tabstop=4                           " <tab> inserts 4 spaces
set shiftwidth=4                        " sw 4 spaces (used on auto indent)
set softtabstop=4                       " 4 spaces as a tab for bs/del
set expandtab                           " Use spaces instead of tabs for autoindent/tab key
set history=1000                        " 1000 Lines of history
set showfulltag                         " Show more information while completing tags
set foldmethod=indent                   " Allow folding on indents
set foldlevel=99                        " Don't fold by default
set foldlevelstart=99                   " Don't fold by default

""" Reading/Writing
set nobackup                        " No backups
set nowritebackup                   " Even when overwriting
set noswapfile                      " Don't use swap files
set noautowrite                     " Never write a file unless I request if.
set noautowriteall                  " Never
set noautoread                      " Don't automatically re-read changed files
set ffs=unix,dos,mac

"""" Searching and Patterns
set ignorecase                          " Default to using case insensitive searches
set smartcase                           " unless uppercase is used in regex.
set hlsearch                            " Highlight matches to the search
set incsearch                           " Incrementally search
nmap <silent> ,/ :nohlsearch<CR>        " Clear highlights


"""" Command Line
set wildmenu                            " Autocomplete features in the status bar
set wildmode=list:longest
set wildignore+=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp   " we don't want to edit these type of files

" allow command line editing like emacs
cnoremap <C-A>      <Home>
cnoremap <C-B>      <Left>
cnoremap <C-E>      <End>
cnoremap <C-F>      <Right>
cnoremap <C-N>      <End>
cnoremap <C-P>      <Up>
cnoremap <ESC>b     <S-Left>
cnoremap <ESC><C-B> <S-Left>
cnoremap <ESC>f     <S-Right>
cnoremap <ESC><C-F> <S-Right>
cnoremap <ESC><C-H> <C-W>


"""" Autocommands
augroup vimrcEx
    au!
    " In plain-text files and svn/git commit buffers, wrap automatically at 78 chars
    au FileType text,svn,gitcommit setlocal tw=78 fo+=t

    " Restore previous cursor position
    au BufWinEnter * call RestoreCursor()

    " Switch to the directory of the current file, unless it's a help file.
    au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif

    "autocmd BufEnter,BufReadPre * silent! cd %:p:h:gs/\\\\/\\/

    " kill calltip window if we move cursor or leave insert mode
    au CursorMovedI * if pumvisible() == 0|pclose|endif
    au InsertLeave * if pumvisible() == 0|pclose|endif
augroup END


"""" Key Mappings
" work more logically with wrapped lines
noremap j gj
noremap k gk

nnoremap ; :
imap jj <Esc>                               " jj in insert mode switches to normal
nmap <leader>p :set invpaste paste?<cr>     " toggle paste mode
nmap <leader>rr :1,$retab<CR>               " Retab file
nmap <F4> :TlistToggle<CR>                  " Toggle the tag list bar
map - :Explore<cr>
cmap w!! %!sudo tee > /dev/null %

nmap <leader>c :copen<CR>                   " Open quickfix window
nmap <leader>cc :cclose<CR>                 " Close quickfix window
nmap <leader>cq :call setqflist([])<CR>     " Clear quickfix window

map <leader>ss :setlocal spell!<cr>     " Toggle spell checking

" bind ctrl+space for omnicompletion
inoremap <Nul> <C-x><C-o>
imap <c-space> <c-x><c-o>

" allow arrow keys when code completion window is up
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>

nnoremap <leader>l :call ToggleRelativeAbsoluteNumber()<CR>
nmap <leader>sb :call SplitScroll()<CR>     " Vsplit with syncronized scrolling
map <C-F12> :call UpdateTags()<CR>          " Update tags of current file
command! Ctag :call CreateTags()<CR>    " Build tags of current file

imap <C-W> <C-O><C-W>               " Window commands work in insert mode
noremap <silent> <leader>h :wincmd h<cr>   " Move the cursor to the window left of the current one
noremap <silent> <leader>j :wincmd j<cr>   " Move the cursor to the window below the current one
noremap <silent> <leader>k :wincmd k<cr>   " Move the cursor to the window above the current one
noremap <silent> <leader>l :wincmd l<cr>   " Move the cursor to the window right of the current one

noremap <silent> <leader>cj :wincmd j<cr>:close<cr>    " Close the window below this one
noremap <silent> <leader>ck :wincmd k<cr>:close<cr>    " Close the window above this one
noremap <silent> <leader>ch :wincmd h<cr>:close<cr>    " Close the window to the left of this one
noremap <silent> <leader>cl :wincmd l<cr>:close<cr>    " Close the window to the right of this one
noremap <silent> <leader>cc :close<cr>                 " Close the current window

noremap <silent> <leader>ml <C-W>L     " Move the current window to the right of the main Vim window
noremap <silent> <leader>mk <C-W>K     " Move the current window to the top of the main Vim window
noremap <silent> <leader>mh <C-W>H     " Move the current window to the left of the main Vim window
noremap <silent> <leader>mj <C-W>J     " Move the current window to the bottom of the main Vim window

" Ctrl + Arrows - Move around quickly
nnoremap  <c-up>     {
nnoremap  <c-down>   }
nnoremap  <c-right>  El
nnoremap  <c-down>   Bh

" Shift + Arrows - Visually Select text
nnoremap  <s-up>     Vk
nnoremap  <s-down>   Vj
nnoremap  <s-right>  vl
nnoremap  <s-left>   vh

" Tab navigation
nmap <leader>tn :tabnext<cr>
nmap <leader>tp :tabprevious<cr>
nmap <leader>te :tabedit<cr>
nnoremap  <a-right>  gt             " Next tab right
nnoremap  <a-left>   gT             " Next tab left

if &diff
    " easily handle diffing
    vnoremap < :diffget<CR>
    vnoremap > :diffput<CR>
else
    " visual shifting (builtin-repeat)
    vnoremap < <gv
    vnoremap > >gv
endif

" git bindings for Fugitive
nmap <leader>gs :Gstatus<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>ga :Gcommit<cr>
nmap <leader>gl :Glog<cr>
nmap <leader>gd :Gdiff<cr>


" Extra functionality for some existing commands:
nnoremap <C-6> <C-6>`"          " <C-6> switches back to the alternate file and the correct column in the line.
nnoremap <C-g> 2<C-g>           " CTRL-g shows filename and buffer number, too.
nnoremap q: q:iq<esc>           " I hate hitting q: instead of :q
nnoremap <silent> <C-l> :nohl<CR><C-l>  " <C-l> redraws the screen and removes any search highlighting.
noremap Q gq                    " Q formats paragraphs, instead of entering ex mode

vnoremap * y/<C-R>"<CR>         " * search next in visual
vnoremap # y?<C-R>"<CR>         " # search previous in visual

nnoremap <space> za             " <space> toggles folds opened and closed
vnoremap <space> zf             " <space> in visual mode creates a fold over the marked range


map <leader>del :g/^\s*$/d<CR>          " Delete Empty Lines
map <leader>ddql :%s/^>\s*>.*//g<CR>    " Delete Double Quoted Lines
map <leader>ddr :s/\.\+\s*/. /g<CR>     " Delete Dot Runs
map <leader>dsr :s/\s\s\+/ /g<CR>       " Delete Space Runs
map <leader>dtw :%s/\s\+$//g<CR>        " Delete Trailing Whitespace

noremap <leader>= gg=G                  " Reindent everything
noremap <leader>gp gqap                 " Reformat paragraph
noremap <leader>gq gggqG                " Reformat everything
noremap <leader>gg ggVG                 " Select everything

" Allow setting window title for screen
if &term =~ '^screen'
    set t_ts=k
    set t_fs=\
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Completion
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-p>"
let g:SuperTabLongestEnhanced=1
let g:SuperTabRetainCompletionDuration = 'completion'
set completeopt=menuone,longest,preview

let g:yankring_history_dir = '~/.vim'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Functions
" Update tags file
function! UpdateTags()
    let tag_file = findfile("tags", ".;")
    if (filereadable(tag_file))
        echo "Updated tag file: " . tag_file
        let e = system(g:ctag_exe.' '.g:ctag_args.' -f '.tag_file.' '.expand('%'))
        "let g:e = system(g:ctag_exe.' '.g:ctag_args.' -f C:"'.expand(tag_file).'" '.expand('%'))
    else
        echo "No tag file found"
    endif
endfunction

" Create tags file
function! CreateTags()
    let tag_file = expand('%:h') .'/'. g:ctag_filename
    echo "Creating tag file: " . tag_file
    let e = system(g:ctag_exe.' '.g:ctag_args.' -f '.tag_file.' '.expand('%'))
endfunction

" Vertical split current file with syncronized scrolling
function! SplitScroll()
    :wincmd v
    :wincmd w
    execute "normal! \<C-d>"
    :set scrollbind
    :wincmd w
    :set scrollbind
endfunction

" Remove trailing whitespace
function! StripTrailingWhitespace()
    let l:winview = winsaveview()
    silent! %s/\s\+$//
    call winrestview(l:winview)
endfunction

" Toggle between absolute and relative numbering 
function! ToggleRelativeAbsoluteNumber()
    if &number
        set relativenumber
    else
        set number
    endif
endfunction

function! RestoreCursor()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction
     


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Haskell
augroup HaskellAuto
    au!
    au Filetype haskell compiler ghc 
    au Filetype haskell setlocal completeopt-=longest
    au FileType haskell let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
augroup END

let g:ghc = "/usr/bin/ghc"
let g:haddock_docdir = "/Library/Haskell/doc/"
"Mac
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"
let g:haddock_indexfiledir="/tmp/haddock/"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Erlang
augroup ErlangAuto
    au!
    " We really want completion to use erlangcomplete#Complete (<c-x><c-o>)
    " first then use local keyword (<c-x><c-p>). Not sure how to do that
    au FileType erlang setlocal omnifunc=erlangcomplete#Complete
    au FileType erlang let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
augroup END

let g:erlangManPath = "/opt/local/lib/erlang/man/"
let g:erlangCompleteFile = "~/.vim/bundle/vimerl/autoload/erlang_complete.erl"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Python
"site package tags: ctags -R -f ~/.vim/tags/python.ctags `python -c "from
"distutils.sysconfig import get_python_lib; print get_python_lib()`
augroup PythonAuto
    au!
    au BufWritePre *.py call StripTrailingWhitespace()
    au Filetype python setlocal omnifunc=pythoncomplete#Complete
    au Filetype python setlocal completefunc=pythoncomplete#Complete

    au Filetype python setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
    au FileType python setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    au FileType python setlocal expandtab
    au FileType python inoremap # #         " Don't outdent hashes
    au FileType python map <buffer> <leader>8 :call Pep8()<CR>

    map <leader>j :RopeGotoDefinition<CR>
    map <leader>r :RopeRename<CR>
augroup END

let g:pyflakes_use_quickfix = 0         " Using quickfix breaks pep8
let g:pep8_args = "--ignore=E501"       " Ignore 'line too long'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" C/C++
augroup CAuto
    au!
    au BufWritePre *.c,*.h call StripTrailingWhitespace()
    au BufWritePost *.c,*.h call UpdateTags()  " Update tags of current c/h file when saving
    "au FileType c set omnifunc=syntaxcomplete#Complete
    au FileType c setlocal completefunc=syntaxcomplete#Complete
    au FileType c let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
    au FileType c let g:SuperTabContextDefaultCompletionType = "<c-x><c-p>"
    au Filetype c setlocal completeopt=menuone,longest,preview
    " Use :make to compile c, even without a makefile
    au FileType c,cpp if glob('Makefile') == "" | let &mp="gcc -o %< %" | endif
    au Filetype c setlocal efm=%f:%l:%c:%m       " Lint compatible
augroup END

function! Lint()
    call setqflist([])   "clear quickfix buffer
    cgetexpr system('"R:\Software\Private\PC-Lint_v9\lint\Lint-nt" -iC:\pc-lint\ std.lnt local.lnt +b *.c')
    copen
endfunction
map <Leader>lint :call Lint()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""' CTags
set tags=./tags;/
set tags+=$HOME/.vim/tags/python.ctags
"set tags+=$HOME/vimfiles/tags/python.ctags
"set tags+=$HOME/vimfiles/tags/integrity.ctags

let g:ctag_filename = "tags"
let g:ctag_args = "-R --append=yes --python-kinds=-i --c-kinds=+pl --c++-kinds=+pl --fields=+iaS --extra=+q"
let g:ctag_exe  = "ctags"

map <C-\> :sp <CR>:exec("tag ".expand("<cword>"))<CR>   " Open tag in hoizontal split
map <A-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>  " Open tag in vertical split


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" GreenHills MULTI
"paths from multi have escaped backslashes
"map <Leader>cd :cd %:p:h:gs/\\\\/\\/<CR>

function! FixMultiPath()
    edit %:t
    bprevious
    bdelete
endfunction
map <Leader>mu :call FixMultiPath()<CR>

