call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set nocompatible
let mapleader=","
nnoremap ; :

" quickly edit/reload vimrc
nmap <silent> <leader>ev :e $MYVIMRC<cr>
nmap <silent> <leader>sv :so $MYVIMRC<cr>
autocmd! bufwritepost $MYVIMRC source $MYVIMRC


"""" Movement
" work more logically with wrapped lines
noremap j gj
noremap k gk

"""" Searching and Patterns
set ignorecase							" search is case insensitive
set smartcase							" search case sensitive if caps on
set incsearch							" show best match so far
set hlsearch							" Highlight matches to the search
nmap <silent> ,/ :nohlsearch            " clear highlights

"toggle spell checking
map <leader>ss :setlocal spell!<cr>

"""" Display
if has("gui_running")
    colorscheme inkpot
else
    colorscheme elflord
endif
set background=dark						" I use dark background
"set lazyredraw							" Don't repaint when scripts are running
set hidden                              " Allow unchanged buffers to hide
set scrolloff=3							" Keep 3 lines below and above the cursor
set ruler								" line numbers and column the cursor is on
set number								" Show line numbering
set numberwidth=1						" Use 1 col + 1 space for numbers
" set title
set titlestring=%F

" tab labels show the filename without path(tail)
set guitablabel=%N/\ %t\ %M

""" Windows
if exists(":tab")						" Try to move to other windows if changing buf
    set switchbuf=useopen,usetab
else									" Try other windows & tabs if available
    set switchbuf=useopen
endif

"""" Messages, Info, Status
set shortmess+=a						" Use [+] [RO] [w] for modified, read-only, modified
set showcmd								" Display what command is waiting for an operator
set ruler								" Show pos below the win if there's no status line
set laststatus=2						" Always show statusline, even if only 1 window
set report=0							" Notify me whenever any lines have changed
set confirm								" Y-N-C prompt if closing with unsaved changes
set vb t_vb=							" Disable visual bell!  I hate that flashing.
"set statusline+=
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y[%{fugitive#statusline()}]
set statusline+=%=%{v:register}\ %c,%l/%L\ %P

"""" Editing
set backspace=indent,eol,start  		" Backspace over anything! (Super backspace!)
set showmatch							" Briefly jump to the previous matching paren
set matchtime=2							" For .2 seconds
set formatoptions-=tc					" I can format for myself, thank you very much
set tabstop=4							" Tab stop of 4
set shiftwidth=4						" sw 4 spaces (used on auto indent)
set softtabstop=4						" 4 spaces as a tab for bs/del
set expandtab
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

" disable gui menu bar
"set guioptions=ac

"""" Coding
set history=1000						" 1000 Lines of history
set showfulltag							" Show more information while completing tags
filetype plugin on						" Enable filetype plugins
filetype plugin indent on				" Let filetype plugins indent for me
syntax on								" Turn on syntax highlighting

" set up tags
set tags=./tags;/
set tags+=$HOME/.vim/tags/python.ctags

" build tags of cur dir with CTRL+F12
map <C-F12> :!ctags -R .<CR>


""""" Folding
set foldmethod=syntax					" By default, use syntax to determine folds
set foldlevelstart=99					" All folds open by default

"""" Command Line
set wildmenu							" Autocomplete features in the status bar
set wildmode=list:longest
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp   " we don't want to edit these type of files

"""" Autocommands
if has("autocmd")
    augroup vimrcEx
        au!
        " In plain-text files and svn commit buffers, wrap automatically at 78 chars
        au FileType text,svn setlocal tw=78 fo+=t

        " In all files, try to jump back to the last spot cursor was in before exiting
        au BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif

        " Use :make to check a script with perl
        au FileType perl set makeprg=perl\ -c\ %\ $* errorformat=%f:%l:%m

        " Use :make to compile c, even without a makefile
        au FileType c,cpp if glob('Makefile') == "" | let &mp="gcc -o %< %" | endif

        " Switch to the directory of the current file, unless it's a help file.
        au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif

        " Insert Vim-version as X-Editor in mail headers
        au FileType mail sil 1  | call search("^$")
                    \ | sil put! ='X-Editor: Vim-' . Version()

        " smart indenting for python
        au FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

        " allows us to run :make and get syntax errors for our python scripts
        au FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
        " setup file type for code snippets
        au FileType python if &ft !~ 'django' | setlocal filetype=python.django_tempate.django_model | endif
        au FileType python set expandtab

        " kill calltip window if we move cursor or leave insert mode
        au CursorMovedI * if pumvisible() == 0|pclose|endif
        au InsertLeave * if pumvisible() == 0|pclose|endif

    augroup END
endif


"""" Key Mappings
"jj in insert mode switches to normal
imap jj <Esc>

" toggle paste mode
nmap ,p :set invpaste paste?<cr>

"set up retabbing on a source file
nmap ,rr :1,$retab

" bind ctrl+space for omnicompletion
inoremap <Nul> <C-x><C-o>
imap <c-space> <c-x><c-o>
"inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
"            \ "\<lt>C-n>" :
"            \ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
"            \ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
"            \ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
"imap <C-@> <C-Space>
"only complete longest common
set completeopt+=longest

" Toggle the tag list bar
nmap <F4> :TlistToggle<CR>

map - :Explore<cr>

cmap w!! %!sudo tee > /dev/null %

" tab navigation (next tab) with alt left / alt right
nnoremap  <a-right>  gt
nnoremap  <a-left>   gT

" Move the cursor to the window left of the current one
noremap <silent> ,h :wincmd h<cr>

" Move the cursor to the window below the current one
noremap <silent> ,j :wincmd j<cr>

" Move the cursor to the window above the current one
noremap <silent> ,k :wincmd k<cr>

" Move the cursor to the window right of the current one
noremap <silent> ,l :wincmd l<cr>

" Close the window below this one
noremap <silent> ,cj :wincmd j<cr>:close<cr>

" Close the window above this one
noremap <silent> ,ck :wincmd k<cr>:close<cr>

" Close the window to the left of this one
noremap <silent> ,ch :wincmd h<cr>:close<cr>

" Close the window to the right of this one
noremap <silent> ,cl :wincmd l<cr>:close<cr>

" Close the current window
noremap <silent> ,cc :close<cr>

" Move the current window to the right of the main Vim window
noremap <silent> ,ml <C-W>L

" Move the current window to the top of the main Vim window
noremap <silent> ,mk <C-W>K

" Move the current window to the left of the main Vim window
noremap <silent> ,mh <C-W>H

" Move the current window to the bottom of the main Vim window
noremap <silent> ,mj <C-W>J

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
" <C-6> switches back to the alternate file and the correct column in the line.
nnoremap <C-6> <C-6>`"

" CTRL-g shows filename and buffer number, too.
nnoremap <C-g> 2<C-g>

" Arg!  I hate hitting q: instead of :q
nnoremap q: q:iq<esc>

" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Q formats paragraphs, instead of entering ex mode
noremap Q gq

" * and # search for next/previous of selected text when used in visual mode
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
vnoremap <space> zf

" allow arrow keys when code completion window is up
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>


" Remove trailing whitespace from code files on save
function! StripTrailingWhitespace()

    " store current cursor location
    silent exe "normal ma<CR>"
    " store the current search value
    let saved_search = @/


    " delete the whitespace (e means don't warn if pattern not found)
    %s/\s\+$//e

    " restore old cursor location
    silent exe "normal `p<CR>"
    " restore the search value
    let @/ = saved_search

endfunction

au BufWritePre *.c,*.h call StripTrailingWhitespace()

" toggle between number and relative number on ,l
nnoremap <leader>l :call ToggleRelativeAbsoluteNumber()<CR>
function! ToggleRelativeAbsoluteNumber()
    if &number
        set relativenumber
    else
        set number
    endif
endfunction

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

" haskell stuff
au Bufenter *.sh compiler ghc
au Filetype haskell set completeopt-=longest
au FileType haskell let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:ghc = "/usr/bin/ghc"
let g:haddock_docdir = "/Library/Haskell/doc/"
"Mac
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"
let g:haddock_indexfiledir="/tmp/haddock/"


let g:erlangManPath = "/opt/local/lib/erlang/man/"
let g:erlangCompleteFile = "~/.vim/bundle/vimerl/autoload/erlang_complete.erl"

let g:SuperTabDefaultCompletionType = "<c-x><c-u>"      " Default onmi-complete
let g:SuperTabLongestEnhanced=1

autocmd FileType erlang let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

let g:yankring_history_dir = '~/.vim'

