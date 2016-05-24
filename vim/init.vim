" => General {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use vim settings, rather than vi settings (much better!)
" Must be first, because it changes other options as a side effect
set nocompatible

set shell=/bin/bash

" Set leader to ' '
let mapleader = " "
let g:mapleader = " "

" }}}
" => Plugins {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dag/vim-fish'
Plug 'digitaltoad/vim-pug'
Plug 'elixir-lang/vim-elixir'
Plug 'elmcast/elm-vim'
Plug 'gregsexton/MatchTag', { 'for': 'html' }
Plug 'isRuslan/vim-es6'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }
Plug 'junegunn/vim-easy-align'
Plug 'nelstrom/vim-markdown-folding'
Plug 'nicklasos/vim-jsx-riot'
Plug 'othree/html5.vim'
Plug 'rking/ag.vim'
Plug 'rhysd/vim-crystal'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] } | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ruby/vim-ruby'
Plug 'wavded/vim-stylus'
Plug 'wting/rust.vim'
Plug 'ryanoasis/vim-devicons'

call plug#end()
" }}}
" => Colors and Fonts {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set t_Co=256
set background=dark
syntax on  " switch syntax highlighting on for color term
let base16colorspace=256
colorscheme base16-railscasts

" }}}
" => Editing Behavior {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent              " always set autoindenting on
set autowrite               " automatically :write before running commands
set backspace=2             " allow backspacing over everything in insert mode
set copyindent              " copy the previous indentation on autoindenting
set cursorline              " underline the current line, for quick orientation
set encoding=utf-8 nobomb   " UTF-8 by default without BOM
set expandtab               " expand tabs by default (overloadable per file type)
set fileformats=unix,dos,mac  " set the ordering for file formats
set formatoptions+=1        " when wrapping paragraphs, don't end lines with 1-letter words
set formatoptions+=2        " use indent from 2nd line of a paragraph
set formatoptions+=c        " format comments
set formatoptions+=l        " don't break lines that are already long
set formatoptions+=n        " recognize numbered lines
set formatoptions+=o        " make comment when using o or O from comment line
set formatoptions+=q        " recognize comments with gq
set formatoptions+=r        " continue comments by default
set formatoptions=
set gdefault                " search/replace 'globally' by default
set hidden                  " hide buffers instead of closing them
set history=50              " remember more commands and search history
set hlsearch                " highlight search terms
set ignorecase              " ignore case when searching
set incsearch               " show search matches as you type
set laststatus=2            " tell vim to always put a status line in
set lazyredraw              " don't update the display when running macros
set listchars=tab:▸\ ,trail:·,extends:#,nbsp:· " set chars used for whitespace
set magic                   " change the way backslahes are used in search patterns
set modeline                " enable modelines
set mouse=a                 " enable using the mouse if terminal emulator supports it
set nobackup                " backup really acts weirdly ... disable it!
set noerrorbells            " don't beep
set nojoinspaces            " only insert space in join after punctuation
set nolist                  " don't show invisible characters by default
set noshowmode              " don't show the current mode since we have airline
set nostartofline           " don't reset cursor to start of line when moving around
set noswapfile
set nowrap                  " don't wrap lines
set nowritebackup
set number                  " always show line numbers
set ruler                   " show location on command line
set scrolloff=4             " keep 4 lines off the edges of the screen when scrolling
set shiftround              " use multiple of shiftwidth when indenting with '>' and '<'
set shiftwidth=2            " number of spaces to use for auto indenting
set showcmd                 " show (partial) command in the last line of the screen
set showmatch               " set show matching parentheses
set showmode                " always show what mode we're in
set smartcase               " ignore case only if search pattern all lowercase
set smarttab                " insert tabs on line start according to shiftwidth
set softtabstop=2           " when hitting <BS>, pretend like tab is removed, even if spaces
set switchbuf=useopen       " reveal already opened files from quickfix
set tabstop=2               " a tab is two spaces
set termencoding=utf-8
set title                   " change the terminal's title
set undofile                " keep a persistent backup file
set undolevels=1000         " use many mucho levels of undo
set viminfo=%,'9999,s512,n~/.vim/viminfo " Restore buffer links, remember 9999 files of marks, remember registers <= 512kb
set virtualedit=block       " allow cursor to go in to 'invalid' places
set visualbell              " don't beep
set wildignore+=*.swp,*.bak,*.pyc,*.class
set wildignore+=*/.git/*
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=bundle/**,vendor/bundle/**
set wildignore+=coverage/*
set wildignore+=tmp/**,*.rbc,*.rbx,*.scssc,*.sassc
set wildmenu                " make tab completion for files/buffer bash-like
set wildmode=list:longest   " complete only to the point of ambiguity
set wrapscan

" Sane regular expressions, via Steve Losh
" See http://stevelosh.com/blog/2010/09/coming-home-to-vim
nnoremap / /\v
vnoremap / /\v

" Speed up srolling of viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" }}}
" => Folding Rules {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set foldenable              " enable folding
set foldlevelstart=10       " start out with everything folded
set foldmethod=syntax       " fold based on the syntax
set foldminlines=0
set foldnestmax=10          " set a max level of nested folding to 10
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                            " which commands trigger auto-fold

function! MyFoldText()
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 2
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth -2 - len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
  return line . ' …' . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction
set foldtext=MyFoldText()

" }}}
" => Shortcut Mappings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set ; to be : as well
nnoremap ; :

" Avoid accidentally hitting F1
noremap! <F1> <Esc>

" Quick closing of current window
nnoremap <leader>q :q<CR>

" Use Q for formatting the current paragraph (or visual selection)
vnoremap Q gq
nnoremap Q gqap

" Make p in visual mode replace the selected text with the yank register
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to marked line, ` jumps to the marked line and col
nnoremap ' `
nnoremap ` '

" Use the damn hjkl keys
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" Remap j and k to act as expected when used on long, wrapped lines
nnoremap j gj
nnoremap k gk

" Easy window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap <leader>w <C-w>v<C-w>l

" Tab configuration
noremap <leader>tn :tabnew<cr>
noremap <leader>te :tabedit<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove

" Complete whole filenames/lines with a quicker shortcut key in insert mode
inoremap <C-f> <C-x><C-f>
inoremap <C-l> <C-x><C-l>

" Quick yanking to the end of the line
nnoremap Y y$

" Yank/paste to the OS clipboard with ,y and ,p
noremap <leader>y "+y
noremap <leader>Y "+yy
noremap <leader>p "+p
noremap <leader>P "+P

" Edit the vimrc file
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

" Clears the search register
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Pull word under cursor into LHS of a substitute (for quick search/replace)
nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" Keep search matches in the middle of the window and pulse the line when
" moving to them
nnoremap n n:call PulseCursorLine()<CR>
nnoremap N N:call PulseCursorLine()<CR>

" Quickly get out of insert mode without moving your fingers
inoremap jk <Esc>

" Quick alignment of text
nnoremap <leader>al :left<CR>
nnoremap <leader>ar :right<CR>
nnoremap <leader>ac :center<CR>

" Scratch
nnoremap <leader><tab> :Sscratch<CR><C-W>x<C-J>

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" Strip all trailing whitespace from a file, using ,W
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Run ack fast
nnoremap <leader>a :Ag<Space>

" Reselect text that was just pasted with ,v
nnoremap <leader>v V`]

" Gundo.vim
nnoremap <leader>u :GundoToggle<CR>

" Make a more accessible <Esc> in insert mode
inoremap jk <Esc>

" Make > and < in visual mode return to visual mode after finishing
vnoremap < <gv
vnoremap > >gv

" Easy alignment
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Writing mode
noremap <leader>G :Goyo<CR>

" }}}
" => Plugin Configuration {{{
  " => Airline Settings {{{
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  augroup airline_config
    autocmd!

    let g:airline_left_step=''
    let g:airline_powerline_fonts = 1
    let g:airline_right_step=''
    let g:airline_theme = 'base16'

    let g:airline#extensions#syntastic#enabled = 1
  augroup END

  " }}}
  " => Ctrl-P Settings {{{
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  augroup ctrlp_config
    autocmd!

    let g:ctrlp_map = '<leader>f'
    let g:ctrlp_match_window = 'top,order:ttb'
    let g:ctrlp_switch_buffer = 0
    let g:ctrlp_use_caching = 0
    let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'
    let g:ctrlp_working_path_mode = 0
  augroup END

  " }}}
  " => NERDTree Settings {{{
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  augroup nerdtree_config
    autocmd!

    nnoremap <leader>n :NERDTreeToggle<CR>

    " Store the bookmarks file
    let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

    " Show the bookmarks table on startup
    let NERDTreeShowBookmarks=1

    " Show hidden files too
    let NERDTreeShowFiles=1
    let NERDTreeShowHidden=1

    " Quit on opening files from the tree
    let NERDTreeQuitOnOpen=1

    " Highlight the selected entry in the tree
    let NERDTreeHighlightCursorline=1

    " Use a single click to fold/unfold directories and a double click to
    " open files
    let NERDTreeMouseMouse=2

    " Don't display these kinds of files
    let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
                        \ '\.o$', '\.so$', '\.egg$', '^\.git$' ]
  augroup END

  " }}}
  " => Syntastic Settings {{{
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  augroup syntastic_config
    autocmd!

    let g:syntastic_error_symbol = '✗'
    let g:syntastic_warning_symbol = '⚠'

    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0

    let g:syntastic_python_checkers = ['flake8']
  augroup END

  " }}}
  " => UltiSnips Settings {{{
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  augroup ultisnips_config
    autocmd!

    " Work around YouCompleteMe
    let g:UltiSnipsExpandTrigger='<c-j>'
  augroup END

  " }}}
  " => Writing Settings {{{
  augroup writing
    autocmd!

    let g:limelight_paragraph_span = 1
    let g:limelight_priority = -1

    function! s:goyo_enter()
      set linebreak
      set wrap
      Limelight
    endfunction

    function! s:goyo_leave()
      set nolinebreak
      set nowrap
      Limelight!
    endfunction

    autocmd User GoyoEnter call <SID>goyo_enter()
    autocmd User GoyoLeave call <SID>goyo_leave()
  augroup end
  " }}}
" }}}
" => Spell Checking {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle and untoggle spell-check with <leader>ss
noremap <leader>ss :setlocal spell!<cr>

" Sane shortcuts
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=

" }}}
" => Filetype Specific Handling {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")
  augroup css_files " {{{
    autocmd!

    autocmd filetype css,less,scss setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 foldmethod=marker foldmarker={,}
  augroup end " }}}
  augroup elm_files " {{{
    autocmd!

    autocmd filetype elm setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
  augroup end " }}}
  augroup git_messages " {{{
    autocmd!

    autocmd filetype gitcommit setlocal spell! spelllang=en_us
  augroup end " }}}
  augroup html_files " {{{
    autocmd!

    autocmd filetype html,html.ruby,xhtml,xml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

    " Auto-closing of HTML/XML tags
    let g:closetag_default_xml=1
    autocmd filetype html,html.ruby let b:closetag_html_style=1
    autocmd filetype html,html.ruby,xhtml,xml source ~/.vim/scripts/closetag.vim
  augroup end " }}}
  augroup javascript_files " {{{
    autocmd!

    autocmd filetype javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
    autocmd filetype javascript setlocal listchars=trail:·,extends:#,nbsp:·
    autocmd filetype javascript setlocal foldmethod=marker foldmarker={,}
    autocmd filetype javascript call JavaScriptFold()
  augroup end " }}}
  augroup invisible_chars " {{{
    autocmd!

    " Show invisible characters in all of these files
    autocmd filetype vim setlocal list
    autocmd filetype python,rst setlocal list
    autocmd filetype ruby setlocal list
    autocmd filetype javascript,css setlocal list
    autocmd filetype html setlocal list
  augroup end " }}}
  augroup php_files " {{{
    autocmd!

    autocmd filetype php setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
    autocmd filetype php setlocal textwidth=120
  augroup end " }}}
  augroup python_files " {{{
    autocmd!

    " PEP8 compliance (set 1 tab = 4 chars explicitly, even if set
    " earlier, as it is important)
    autocmd filetype python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
    autocmd filetype python setlocal textwidth=80
    autocmd filetype python match ErrorMsg '\%>80v.\+'

    " But disable autowrapping as it is super annoying
    autocmd filetype python setlocal formatoptions-=t

    " Folding for Python (uses syntax/python.vim for fold definitions)
    "autocmd filetype python,rst setlocal nofoldenable
    "autocmd filetype python setlocal foldmethod=expr

    " Python runners
    autocmd filetype python noremap <buffer> <F5> :w<CR>:!python %<CR>
    autocmd filetype python inoremap <buffer> <F5> <Esc>:w<CR>:!python %<CR>
    autocmd filetype python noremap <buffer> <S-F5> :w<CR>:!ipython %<CR>
    autocmd filetype python inoremap <buffer> <S-F5> <Esc>:w<CR>:!ipython %<CR>
  augroup end " }}}
  augroup rst_files " {{{
    autocmd!

    " Auto-wrap text around 74 characters
    autocmd filetype rst setlocal textwidth=74
    autocmd filetype rst setlocal formatoptions+=nqt
    autocmd filetype rst match ErrorMsg '\%>74v.\+'
  augroup end " }}}
  augroup ruby_files " {{{
    autocmd!

    autocmd filetype ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  augroup end " }}}
  augroup textile_files " {{{
    autocmd!

    autocmd filetype textile set textwidth=78 wrap

    " Render YAML front matter inside Textile documents as comments
    autocmd filetype textile syntax region frontmatter start=/\%^---$/ end=/^---$/
    autocmd filetype textile highlight link frontmatter Comment
  augroup end " }}}
  augroup vim_files " {{{
    autocmd!

    " Bind <F1> to show the keyword under the cursor
    " General help can still be entered manually, with :help
    autocmd filetype vim noremap <buffer> <F1> <Esc>:help <C-r><C-w><CR>
    autocmd filetype vim noremap! <buffer> <F1> <Esc>:help <C-r><C-w><CR>
    autocmd filetype vim setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  augroup end " }}}
  augroup whitespace_chars " {{{
    autocmd!

    autocmd BufWritePre *.* :call <SID>StripTrailingWhitespace()
  augroup end " }}}
  augroup yaml_files " {{{
    autocmd!

    autocmd filetype yaml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  augroup end " }}}
endif

" }}}
" => Python Mode Configuration {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't run pylint on every save - handled by Flake8
let g:pymode_lint = 0
let g:pymode_lint_write = 0

" }}}
" => Miscellaneous {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Restore cursor position upon reopening files, except for gitcommits
autocmd BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \  exe "normal! g`\"" |
  \ endif

" Common abbreviations/misspellings
source ~/.vim/autocorrect.vim

" Helper function for search
function! PulseCursorLine()
  let current_window = winnr()

  windo set nocursorline
  execute current_window . 'wincmd w'

  setlocal cursorline

  redir => old_hi
  silent execute 'hi CursorLine'
  redir END
  let old_hi = split(old_hi, '\n')[0]
  let old_hi = substitute(old_hi, 'xxx', '', '')

  hi CursorLine guibg=#3a3a3a
  redraw
  sleep 20m

  hi CursorLine guibg=#4a4a4a
  redraw
  sleep 30m

  hi CursorLine guibg=#3a3a3a
  redraw
  sleep 30m

  hi CursorLine guibg=#2a2a2a
  redraw
  sleep 20m

  execute 'hi ' . old_hi

  windo set cursorline
  execute current_window . 'wincmd w'
endfunction

" Fix Windows ^M encoding problem
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Strips trailing whitespace at the end of lines
function! <SID>StripTrailingWhitespace()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

" }}}
" vim:foldmethod=marker:foldlevel=0
