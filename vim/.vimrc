"       _       _
"      (_)   __(_)___ ___
"     / / | / / / __ `__ \
"    / /| |/ / / / / / / /
"   /_/ |___/_/_/ /_/ /_/
"
"   Main Contributor: Xiao-Ou Zhang (kepbod) <kepbod@gmail.com>
"   Version: 3.0
"   Created: 2012-01-20
"   Last Modified: 2016-12-29
"
"   Sections:
"     -> ivim Setting
"     -> General
"     -> Platform Specific Setting
"     -> Vim-plug
"     -> User Interface
"     -> Colors and Fonts
"     -> Indent Related
"     -> Search Related
"     -> Fold Related
"     -> Key Mapping
"     -> Pluginin Setting
"     -> Local Setting
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"------------------------------------------------
" => ivim Setting
"------------------------------------------------

" ivim user setting
let g:ivim_user='Xiao-Ou Zhang' " User name
let g:ivim_email='kepbod@gmail.com' " User email
let g:ivim_github='https://github.com/kepbod' " User github
" ivim color settings (hybrid, gruvbox solarized or tender)
let g:ivim_default_scheme='solarized'
" ivim ui setting
let g:ivim_fancy_font=1 " Enable using fancy font
let g:ivim_show_number=1 " Enable showing number
" ivim autocomplete setting (YCM or NEO)
let g:ivim_autocomplete='NEO'
" ivim plugin setting
let g:ivim_bundle_groups=['ui', 'enhance', 'move', 'navigate',
            \'complete', 'compile', 'language']

" Customise ivim settings for personal usage
if filereadable(expand($HOME . '/.vimrc.ivim.local'))
    source $HOME/.vimrc.ivim.local
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"------------------------------------------------
" => General
"------------------------------------------------

set nocompatible " Get out of vi compatible mode
filetype plugin indent on " Enable filetype
let mapleader=',' " Change the mapleader
let maplocalleader='\' " Change the maplocalleader
set timeoutlen=500 " Time to wait for a command

" Source the vimrc file after saving it
autocmd BufWritePost $MYVIMRC source $MYVIMRC
" Fast edit the .vimrc file using ,x
nnoremap <Leader>x :tabedit $MYVIMRC<CR>

set autoread " Set autoread when a file is changed outside
set autowrite " Write on make/shell commands
set hidden " Turn on hidden"

set history=1000 " Increase the lines of history
set modeline " Turn on modeline
set completeopt+=longest " Optimize auto complete
set completeopt-=preview " Optimize auto complete

"设置编码格式
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set encoding=utf-8		"使用utf-8打开文件
set termencoding=utf-8	"设置终端显示编码

hi Visual gui=reverse guifg=Black guibg=Grey	"VISUAL 模式后高亮选中的字符
set undofile " Set undo

" Set directories
function! InitializeDirectories()
    let parent=$HOME
    let prefix='.vim'
    let dir_list={
                \ 'backup': 'backupdir',
                \ 'view': 'viewdir',
                \ 'swap': 'directory',
                \ 'undo': 'undodir',
                \ 'cache': '',
                \ 'session': ''}
    for [dirname, settingname] in items(dir_list)
        let directory=parent.'/'.prefix.'/'.dirname.'/'
        if !isdirectory(directory)
            if exists('*mkdir')
                let dir = substitute(directory, "/$", "", "")
                call mkdir(dir, 'p')
            else
                echo 'Warning: Unable to create directory: '.directory
            endif
        endif
        if settingname!=''
            exe 'set '.settingname.'='.directory
        endif
    endfor
endfunction
call InitializeDirectories()

autocmd BufWinLeave *.* silent! mkview " Make Vim save view (state) (folds, cursor, etc)
autocmd BufWinEnter *.* silent! loadview " Make Vim load view (state) (folds, cursor, etc)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"-------------------------------------------------
" => Platform Specific Setting
"-------------------------------------------------

" On Windows, also use .vim instead of vimfiles
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
else
    set runtimepath+=~/.vim/bundle/Vundle.vim
endif

set viewoptions+=slash,unix " Better Unix/Windows compatibility
set viewoptions-=options " in case of mapping change

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"--------------------------------------------------
" => Vim-plug
"--------------------------------------------------

"if empty(glob('~/.vim/autoload/plug.vim'))
"    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"    autocmd VimEnter * PluginInstall | source $MYVIMRC
"endif

" => vundle
call vundle#begin('~/.vim/bundle')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
if count(g:ivim_bundle_groups, 'ui') " UI setting
    Plugin 'kristijanhusak/vim-hybrid-material' " Colorscheme hybrid material
    Plugin 'morhetz/gruvbox' " Colorscheme gruvbox
    Plugin 'jacoborus/tender.vim' " Colorscheme tender
	Plugin 'lifepillar/vim-solarized8'	"Colorschem solarized8_high
    Plugin 'vim-airline/vim-airline' | Plugin 'vim-airline/vim-airline-themes' " Status line
    Plugin 'Yggdroot/indentLine' " Indentation level
    Plugin 'ryanoasis/vim-devicons' " Devicons
    Plugin 'bling/vim-bufferline' " Buffer line
    Plugin 'mhinz/vim-startify' " Start page
    Plugin 'junegunn/goyo.vim', { 'for': 'markdown' } " Distraction-free
    Plugin 'junegunn/limelight.vim', { 'for': 'markdown' } " Hyperfocus-writing
endif

if count(g:ivim_bundle_groups, 'enhance') " Vim enhancement
    Plugin 'Raimondi/delimitMate' " Closing of quotes
    Plugin 'tomtom/tcomment_vim' " Commenter
    Plugin 'tpope/vim-abolish' " Abolish
    Plugin 'tpope/vim-speeddating' " Speed dating
    Plugin 'tpope/vim-repeat' " Repeat
    Plugin 'terryma/vim-multiple-cursors' " Multiple cursors
    Plugin 'junegunn/vim-slash' " In-buffer search
    Plugin 'mbbill/undotree', { 'on': 'UndotreeToggle' } " Undo tree
    Plugin 'tpope/vim-surround' " Surround
    Plugin 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] } " Easy align
    Plugin 'ludovicchabant/vim-gutentags' " Manage tag files
    Plugin 'AndrewRadev/splitjoin.vim' " Splitjoin
    Plugin 'sickill/vim-pasta' " Vim pasta
    Plugin 'Keithbsmiley/investigate.vim' " Helper
    Plugin 'wikitopian/hardmode' " Hard mode
    Plugin 'wellle/targets.vim' " Text objects
    Plugin 'roman/golden-ratio' " Resize windows
    Plugin 'chrisbra/vim-diff-enhanced' " Create better diffs
endif

if count(g:ivim_bundle_groups, 'move') " Moving
    Plugin 'tpope/vim-unimpaired' " Pairs of mappings
    Plugin 'Lokaltog/vim-easymotion' " Easy motion
    Plugin 'kepbod/quick-scope' " Quick scope
    Plugin 'yuttie/comfortable-motion.vim' " Comfortable motion
    Plugin 'bkad/CamelCaseMotion' " Camel case motion
    Plugin 'majutsushi/tagbar' " Tag bar
    Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  } " Fuzzy finder
    Plugin 'junegunn/fzf.vim' " Fuzzy finder plugin
endif

if count(g:ivim_bundle_groups, 'navigate') " Navigation
    Plugin 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " NERD tree
    Plugin 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' } " NERD tree git plugin
    Plugin 'mhinz/vim-tmuxify' " Tmux panes
endif

if count(g:ivim_bundle_groups, 'complete') " Completion
    if g:ivim_autocomplete=='NEO'
        if has('lua')
            let g:ivim_completion_engine='neocomplete'
            Plugin 'Shougo/neocomplete.vim' " Auto completion framework
        else
            let g:ivim_completion_engine='neocomplcache'
            Plugin 'Shougo/neocomplcache.vim' " Auto completion framework
        endif
        Plugin 'Shougo/neosnippet.vim' " Snippet engine
        Plugin 'Shougo/neosnippet-snippets' " Snippets
        "Plugin 'Shougo/vimproc.vim', { 'do': 'make' }
        Plugin 'wellle/tmux-complete.vim' " Completion for tmux panes
    else
        " Auto completion framework
        let g:ivim_completion_engine='YouCompleteMe'
        Plugin 'Valloric/YouCompleteMe', { 'do': './install.py' } "Auto completion framework
        Plugin 'honza/vim-snippets' " Snippets
        Plugin 'sirver/ultisnips' " Snippet engine
    endif
endif

if count(g:ivim_bundle_groups, 'compile') " Compiling
    Plugin 'scrooloose/syntastic' " Syntax checking
    Plugin 'xuhdev/SingleCompile' " Single compile
endif

if count(g:ivim_bundle_groups, 'git') " Git
    Plugin 'tpope/vim-fugitive' " Git wrapper
    Plugin 'junegunn/gv.vim' " Gitk clone
    if has('signs')
        Plugin 'airblade/vim-gitgutter' " Git diff sign
    endif
endif

if count(g:ivim_bundle_groups, 'language') " Language Specificity
    Plugin 'davidhalter/jedi-vim', { 'for': 'python' } " Python jedi plugin
    Plugin 'fatih/vim-go', { 'for': 'go' } " Golang
    Plugin 'tpope/vim-rails', { 'for': [] } " Rails
    Plugin 'mattn/emmet-vim', { 'for': ['html', 'css'] } " Emmet
    Plugin 'LaTeX-Box-Team/LaTeX-Box' " LaTex
    Plugin 'sheerun/vim-polyglot' " Language Support
endif

if filereadable(expand($HOME . '/.vimrc.bundles.local')) " Load local bundles
    source $HOME/.vimrc.bundles.local
endif

call vundle#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"-------------------------------------------------
" => User Interface
"-------------------------------------------------

if count(g:ivim_bundle_groups, 'ui')
    let g:airline#extensions#tabline#enabled=1
else
    " Set title
    set title
    set titlestring=%t%(\ %m%)%(\ (%{expand('%:p:h')})%)%(\ %a%)

    " Set tabline
    set showtabline=2 " Always show tab line
    " Set up tab labels
    set guitablabel=%m%N:%t[%{tabpagewinnr(v:lnum)}]
    set tabline=%!MyTabLine()
    function! MyTabLine()
        let s=''
        let t=tabpagenr() " The index of current page
        let i=1
        while i<=tabpagenr('$') " From the first page
            let buflist=tabpagebuflist(i)
            let winnr=tabpagewinnr(i)
            let s.=(i==t ? '%#TabLineSel#' : '%#TabLine#')
            let s.='%'.i.'T'
            let s.=' '
            let bufnr=buflist[winnr-1]
            let file=bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            let m=''
            if getbufvar(bufnr, '&modified')
                let m='[+]'
            endif
            if buftype=='nofile'
                if file=~'\/.'
                    let file=substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file=fnamemodify(file, ':p:t')
            endif
            if file==''
                let file='[No Name]'
            endif
            let s.=m
            let s.=i.':'
            let s.=file
            let s.='['.winnr.']'
            let s.=' '
            let i=i+1
        endwhile
        let s.='%T%#TabLineFill#%='
        let s.=(tabpagenr('$')>1 ? '%999XX' : 'X')
        return s
    endfunction
    " Set tabline colorscheme
    if g:ivim_default_scheme=='gruvbox'
        let g:gruvbox_invert_tabline=1
    endif
    " Set up tab tooltips with each buffer name
    set guitabtooltip=%F
endif

" Set status line
if count(g:ivim_bundle_groups, 'ui')
    set laststatus=2 " Show the statusline
    set noshowmode " Hide the default mode text
    " Set status line colorscheme
    if g:ivim_default_scheme=='hybrid'
        let g:airline_theme='bubblegum'
    elseif g:ivim_default_scheme=='tender'
        let g:tender_airline=1
        let g:airline_theme='tender'
    endif
    set ttimeoutlen=50
    let g:bufferline_echo=0
    let g:bufferline_modified='[+]'
    if g:ivim_fancy_font
        let g:airline_powerline_fonts=1
		if !exists('g:airline_symbols')
			let g:airline_symbols={}
		endif
    else
        let g:airline_left_sep=''
        let g:airline_right_sep=''
    endif
endif

" Only have cursorline in current window and in normal window
autocmd WinLeave * set nocursorline
autocmd WinEnter * set cursorline
autocmd InsertEnter * set nocursorline
autocmd InsertLeave * set cursorline
set wildmenu " Show list instead of just completing
set wildmode=list:longest,full " Use powerful wildmenu
set shortmess=at " Avoids hit enter
set showcmd " Show cmd

set backspace=indent,eol,start " Make backspaces delete sensibly
set whichwrap+=h,l,<,>,[,] " Backspace and cursor keys wrap to
set virtualedit=block,onemore " Allow for cursor beyond last character
set scrolljump=5 " Lines to scroll when cursor leaves screen
set scrolloff=3 " Minimum lines to keep above and below cursor
set sidescroll=1 " Minimal number of columns to scroll horizontally
set sidescrolloff=10 " Minimal number of screen columns to keep away from cursor

set showmatch " Show matching brackets/parenthesis
set matchtime=2 " Decrease the time to blink

if g:ivim_show_number
    set number " Show line numbers
    " Toggle relativenumber
    nnoremap <Leader>n :set relativenumber!<CR>
endif

set formatoptions+=rnlmM " Optimize format options
set wrap " Set wrap
set textwidth=80 " Change text width
if g:ivim_fancy_font
    "set list " Show these tabs and spaces and so on
    set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮ " Change listchars
    set linebreak " Wrap long lines at a blank
    set showbreak=↪  " Change wrap line break
    set fillchars=diff:⣿,vert:│ " Change fillchars
    augroup trailing " Only show trailing whitespace when not in insert mode
        autocmd!
        autocmd InsertEnter * :set listchars-=trail:⌴
        autocmd InsertLeave * :set listchars+=trail:⌴
    augroup END
endif

" Set gVim UI setting
if has('gui_running')
    set guioptions-=m
    set guioptions-=T
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"-------------------------------------------------
" => Colors and Fonts
"-------------------------------------------------

syntax on " Enable syntax
set background=dark " Set background
if !has('gui_running')
    set t_Co=256 " Use 256 colors
endif

" Use true colors
if (empty($TMUX))
    if (has("termguicolors"))
		let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
		let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        set termguicolors
    endif
endif

" Load a colorscheme
if count(g:ivim_bundle_groups, 'ui')
    if g:ivim_default_scheme=='hybrid'
        "colorscheme hybrid_reverse
		colorscheme hybrid_material
    elseif g:ivim_default_scheme=='gruvbox'
        colorscheme gruvbox
    elseif g:ivim_default_scheme=='tender'
        colorscheme tender
	elseif g:ivim_default_scheme=='solarized'
        colorscheme solarized8_high
    endif
else
    colorscheme desert
endif

" Set GUI font
if has('gui_running')
    if has('gui_gtk')
        set guifont=DejaVu\ Sans\ Mono\ 18
    else
        set guifont=DejaVu\ Sans\ Mono:h18
    endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"-------------------------------------------------
" => Indent Related
"-------------------------------------------------

set autoindent " Preserve current indent on new lines
set cindent " set C style indent
set expandtab " Convert all tabs typed to spaces
set softtabstop=4 " Indentation levels every four columns
set shiftwidth=4 " Indent/outdent by four columns
set shiftround " Indent/outdent to nearest tabstop

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"-------------------------------------------------
" => Search Related
"-------------------------------------------------

set ignorecase " Case insensitive search
set smartcase " Case sensitive when uc present
set hlsearch " Highlight search terms
set incsearch " Find as you type search
set gdefault " turn on g flag

" Use sane regexes
nnoremap / /\v
vnoremap / /\v
cnoremap s/ s/\v
nnoremap ? ?\v
vnoremap ? ?\v
cnoremap s? s?\v

" Use ,Space to toggle the highlight search
nnoremap <Leader><Space> :set hlsearch!<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"-------------------------------------------------
" => Fold Related
"-------------------------------------------------

set foldlevelstart=0 " Start with all folds closed
set foldcolumn=1 " Set fold column

" Space to toggle and create folds.
nnoremap <silent> <Space> @=(foldlevel('.') ? 'za' : '\<Space>')<CR>
vnoremap <Space> zf

" Set foldtext
function! MyFoldText()
    let line=getline(v:foldstart)
    let nucolwidth=&foldcolumn+&number*&numberwidth
    let windowwidth=winwidth(0)-nucolwidth-3
    let foldedlinecount=v:foldend-v:foldstart+1
    let onetab=strpart('          ', 0, &tabstop)
    let line=substitute(line, '\t', onetab, 'g')
    let line=strpart(line, 0, windowwidth-2-len(foldedlinecount))
    let fillcharcount=windowwidth-len(line)-len(foldedlinecount)
    return line.'…'.repeat(' ',fillcharcount).foldedlinecount.'L'.' '
endfunction
set foldtext=MyFoldText()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"-------------------------------------------------
" => Key Mapping
"-------------------------------------------------

" Make j and k work the way you expect
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Navigation between windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Repeat last substitution, including flags, with &.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" Select entire buffer
nnoremap vaa ggvGg_

" Strip all trailing whitespace in the current file
nnoremap <Leader>q :%s/\s\+$//<CR>:let @/=''<CR>

" Modify all the indents
nnoremap \= gg=G

" See the differences between the current buffer and the file it was loaded from
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
            \ | diffthis | wincmd p | diffthis

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"--------------------------------------------------
" => Pluginin Setting
"--------------------------------------------------

" Setting for UI plugins
if count(g:ivim_bundle_groups, 'ui')

    " -> Startify
    let g:startify_session_dir=$HOME . '/.vim/session'
    let g:startify_custom_header=[
                \'       _       _         ',
                \'      (_)   __(_)___ ___ ',
                \'     / / | / / / __ `__ \',
                \'    / /| |/ / / / / / / /',
                \'   /_/ |___/_/_/ /_/ /_/ ',
                \'                         ']
    let g:startify_custom_footer=['', '    This configuration is maintained by Xiao-Ou Zhang <kepbod@gmail.com> and other contributors. Thanks!']
    if has('gui_running')
        hi StartifyHeader  guifg=#87afff
        hi StartifyFooter  guifg=#87afff
        hi StartifyBracket guifg=#585858
        hi StartifyNumber  guifg=#ffaf5f
        hi StartifyPath    guifg=#8a8a8a
        hi StartifySlash   guifg=#585858
    else
        hi StartifyHeader  ctermfg=111
        hi StartifyFooter  ctermfg=111
        hi StartifyBracket ctermfg=240
        hi StartifyNumber  ctermfg=215
        hi StartifyPath    ctermfg=245
        hi StartifySlash   ctermfg=240
    endif

    " -> Goyo & Limelight
    autocmd! User GoyoEnter Limelight
    autocmd! User GoyoLeave Limelight!

endif

" Setting for enhancement plugins
if count(g:ivim_bundle_groups, 'enhance')

    " -> delimitMate
    let delimitMate_expand_cr=1
    let delimitMate_expand_space=1
    let delimitMate_balance_matchpairs=1

    " -> Tcomment
    " Map \<Space> to commenting
    function! IsWhiteLine()
        if (getline('.')=~'^$')
            exe 'TCommentBlock'
            normal! j
        else
            normal! A   
            exe 'TCommentRight'
            normal! l
            normal! x
        endif
        startinsert!
    endfunction
    nnoremap <silent> <LocalLeader><Space> :call IsWhiteLine()<CR>

    " -> Multiple cursors
    " Called once right before you start selecting multiple cursors
    if g:ivim_autocomplete=='NEO'
        function! Multiple_cursors_before()
            if g:ivim_completion_engine=='neocomplete'
                exe 'NeoCompleteLock'
            else
                exe 'NeoComplCacheLock'
            endif
        endfunction
        " Called once only when the multiple selection is canceled (default <Esc>)
        function! Multiple_cursors_after()
            if g:ivim_completion_engine=='neocomplete'
                exe 'NeoCompleteUnlock'
            else
                exe 'NeoComplCacheUnlock'
            endif
        endfunction
    endif

    " -> Undo tree
    nnoremap <Leader>u :UndotreeToggle<CR>
    let g:undotree_SetFocusWhenToggle=1

    " -> Easy Align
    xmap ga <Plugin>(EasyAlign)
    nmap ga <Plugin>(EasyAlign)

    " -> Gutentags
    let g:gutentags_cache_dir=$HOME . '/.vim/cache/ctags'

    " -> Splitjoin
    let g:splitjoin_split_mapping = ',s'
    let g:splitjoin_join_mapping  = ',j'
    let g:splitjoin_normalize_whitespace=1
    let g:splitjoin_align=1

    " -> Investigate.vim
    nnoremap K :call investigate#Investigate()<CR>
    let g:investigate_use_dash=1

    " -> EnhancedDiff
    let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'

endif

" setting for moving plugins
if count(g:ivim_bundle_groups, 'move')

    " -> Tag bar
    nnoremap <Leader>t :TagbarToggle<CR>
    let g:tagbar_autofocus=1
    let g:tagbar_expand=1
    let g:tagbar_foldlevel=2
    let g:tagbar_autoshowtag=1

    " Matchit
    " Start mathit
    packadd! matchit
    " Use Tab instead of % to switch
    nmap <Tab> %
    vmap <Tab> %

endif

" Setting for navigation plugins
if count(g:ivim_bundle_groups, 'navigate')

    " -> NERD Tree
    nnoremap <Leader>f :NERDTreeToggle<CR>
    let NERDTreeChDirMode=2
    let NERDTreeShowBookmarks=1
    let NERDTreeShowHidden=1
    let NERDTreeShowLineNumbers=1
    augroup nerd_loader
        autocmd!
        autocmd VimEnter * silent! autocmd! FileExplorer
        autocmd BufEnter,BufNew *
                    \  if isdirectory(expand('<amatch>'))
                    \|   call plug#load('nerdtree')
                    \|   execute 'autocmd! nerd_loader'
                    \| endif
    augroup END

endif

" Setting for completion plugins
if count(g:ivim_bundle_groups, 'complete')

    if g:ivim_autocomplete=='NEO'
        " -> Neocomplete & Neocomplcache
        " Use Tab and S-Tab to select candidate
        inoremap <expr><Tab>  pumvisible() ? "\<C-N>" : "\<Tab>"
        inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"
        if g:ivim_completion_engine=='neocomplete'
            let g:neocomplete#enable_at_startup=1
            let g:neocomplete#data_directory=$HOME . '/.vim/cache/neocomplete'
            let g:neocomplete#enable_auto_delimiter=1
            " Use <C-E> to close popup
            inoremap <expr><C-E> neocomplete#cancel_popup()
            inoremap <expr><CR> delimitMate#WithinEmptyPair() ?
                        \ "\<C-R>=delimitMate#ExpandReturn()\<CR>" :
                        \ pumvisible() ? neocomplete#close_popup() : "\<CR>"
        else
            let g:neocomplcache_enable_at_startup=1
            let g:neocomplcache_temporary_dir=$HOME . '/.vim/cache/neocomplcache'
            let g:neocomplcache_enable_auto_delimiter=1
            let g:neocomplcache_enable_fuzzy_completion=1
            " Use <C-E> to close popup
            inoremap <expr><C-E> neocomplcache#cancel_popup()
            inoremap <expr><CR> delimitMate#WithinEmptyPair() ?
                        \ "\<C-R>=delimitMate#ExpandReturn()\<CR>" :
                        \ pumvisible() ? neocomplcache#close_popup() : "\<CR>"
        endif
        " Setting for specific language
        if has('lua')
            if !exists('g:neocomplete#force_omni_input_patterns')
                let g:neocomplete#force_omni_input_patterns={}
            endif
            let g:neocomplete#force_omni_input_patterns.python=
            \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
        else
            if !exists('g:neocomplcache_force_omni_patterns')
                let g:neocomplcache_force_omni_patterns={}
            endif
            let g:neocomplcache_force_omni_patterns.python=
            \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
        endif
        autocmd FileType python setlocal omnifunc=jedi#completions
        let g:jedi#completions_enabled=0
        let g:jedi#auto_vim_configuration=0
        let g:jedi#smart_auto_mappings=0
        let g:jedi#use_tabs_not_buffers=1
        let g:tmuxcomplete#trigger=''
        " -> Neosnippet
        " Set information for snippets
        let g:neosnippet#enable_snipmate_compatibility=1
        " Use <C-K> to expand or jump snippets in insert mode
        imap <C-K> <Plugin>(neosnippet_expand_or_jump)
        " Use <C-K> to replace TARGET within snippets in visual mode
        xmap <C-K> <Plugin>(neosnippet_start_unite_snippet_target)
        " For snippet_complete marker
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif
    else
        " -> UltiSnips
        let g:UltiSnipsExpandTrigger="<C-K>"
        let g:UltiSnipsJumpForwardTrigger="<Tab>"
        let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
    endif

    " Setting info for snips
    let g:snips_author=g:ivim_user
    let g:snips_email=g:ivim_email
    let g:snips_github=g:ivim_github

endif

" Setting for compiling plugins
if count(g:ivim_bundle_groups, 'compile')

    " -> Syntastic
    let g:syntastic_check_on_open=1
    let g:syntastic_aggregate_errors=1
    let g:syntastic_auto_jump=1
    let g:syntastic_auto_loc_list=1
    if g:ivim_fancy_font
        let g:syntastic_error_symbol = '>>'
        let g:syntastic_style_error_symbol = '>'
        let g:syntastic_warning_symbol = '∆'
        let g:syntastic_style_warning_symbol = '≈'
    endif

    " -> Singlecompile
    nnoremap <Leader>r :SingleCompileRun<CR>
    let g:SingleCompile_showquickfixiferror=1

endif

" Setting for git plugins
if count(g:ivim_bundle_groups, 'git')
endif

" Setting for language specificity
if count(g:ivim_bundle_groups, 'language')

    " -> Emmet
    let g:user_emmet_leader_key='<C-Z>'
    let g:user_emmet_settings={'indentation':'    '}
    let g:use_emmet_complete_tag=1

    " -> Polyglot
    let g:vim_markdown_conceal=0

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"--------------------------------------------------
" => Local Setting
"--------------------------------------------------

" Use local vimrc if available
if filereadable(expand($HOME . '/.vimrc.local'))
    source $HOME/.vimrc.local
endif

" Use local gvimrc if available and gui is running
if has('gui_running')
    if filereadable(expand($HOME . '/.gvimrc.local'))
        source $HOME/.gvimrc.local
    endif
endif
