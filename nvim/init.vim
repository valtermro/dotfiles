"= Basics {{{1
"==================================================
filetype indent on

set hidden
set nobackup
set noswapfile
set nowritebackup
set pastetoggle=<F10>
set fileformats=unix,dos,mac

set nowrap
" set textwidth=100

set expandtab
set smartindent
set tabstop=2
set softtabstop=2
set shiftwidth=2

set wildignore+=*/tmp/*,*/node_modules/*,*/vendor/*
set wildmode=longest,list

set number
set relativenumber
set showcmd
set splitright
set colorcolumn=80
set diffopt+=vertical
set foldcolumn=0
set foldlevelstart=0
set scrolloff=3
set showbreak=\ ❯
set invlist
set listchars=tab:›\ ,trail:⋅,extends:❯,precedes:❮ ",eol:¬

set ignorecase
set nohlsearch
set smartcase

"= Filetype {{{1
"==================================================
" neovim's ftdetect and ftplugin directories may cause problems with some plugins

augroup filetype_detect
  autocmd!
  autocmd BufRead,BufNewFile *.tmux setf tmux
  autocmd BufRead,BufNewFile *.mutt setf muttrc
  autocmd BufRead,BufNewFile *.blade.php setf blade

  autocmd BufRead,BufNewFile */git/* setf gitconfig
augroup END

augroup filetype_plugin
  autocmd FileType php,blade setl tabstop=4 | setl softtabstop=4 | setl shiftwidth=4
  autocmd FileType python setl tabstop=4 | setl softtabstop=4 | setl shiftwidth=4
  autocmd FileType xml setl tabstop=4 | setl softtabstop=4 | setl shiftwidth=4

  autocmd FileType vim,zsh,tmux,muttrc,sh setl foldmethod=marker
augroup END

"= Mappings {{{1
"==================================================
nnoremap ' `
nnoremap ` '

nnoremap [3 <C-^>

nnoremap Q n.
nnoremap <C-q> ;.

nnoremap <C-Up> :resize +5<CR>
nnoremap <C-Right> :vertical resize +5<CR>
nnoremap <C-Down> :resize -5<CR>
nnoremap <C-Left> :vertical resize -5<CR>

nnoremap <M-k> <C-W>k
nnoremap <M-j> <C-W>j
nnoremap <M-l> <C-W>l
nnoremap <M-h> <C-W>h

cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

nnoremap <Leader>cul :set cursorline!<CR>

nnoremap <Leader>= mtgg=G't

nnoremap X "_dd
nnoremap D "_D
nnoremap S "_S
xnoremap x "_x

nnoremap / /\v
nnoremap ? ?\v
nnoremap + :set hlsearch<CR>mt*`t
nnoremap - :set nohlsearch<CR>
nnoremap <C-l> :nohlsearch<CR>

nnoremap <C-E> 5<C-E>
nnoremap <C-Y> 5<C-Y>
nnoremap <C-O> <C-O>zz
nnoremap <C-I> <C-I>zz

"= Motions {{{1
"==================================================
" all no-blank characters in the current line
xnoremap <silent> il :<C-U>normal! $v^<CR>
onoremap <silent> il :<C-U>normal! $v^<CR>

" The entire line except the EOF character
xnoremap <silent> al :<C-U>normal! $v0<CR>
onoremap <silent> al :<C-U>normal! $v0<CR>

" the entire file
xnoremap <silent> af :<C-U>normal! GVgg<CR>
onoremap <silent> af :normal GVgg<CR>

"= Pugins {{{1
"==================================================
set runtimepath+=$XDG_DATA_HOME/dein.vim/repos/github.com/Shougo/dein.vim/
call dein#begin($XDG_DATA_HOME.'/dein.vim')
call dein#add('Shougo/dein.vim')
call dein#add('haya14busa/dein-command.vim')

"- Basic features
"--------------------------------------------------
call dein#add('editorconfig/editorconfig-vim')
call dein#add('pbrisbin/vim-mkdir')
call dein#add('nelstrom/vim-visual-star-search')
call dein#add('tpope/vim-repeat')
call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-unimpaired')
call dein#add('tomtom/tcomment_vim')
call dein#add('terryma/vim-multiple-cursors')

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"- Code quality
"--------------------------------------------------
call dein#add('w0rp/ale')

let g:ale_set_signs = 0
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_linters = get(g:, 'ale_linters', {})
let g:ale_linters.html= []

"- Source control
"--------------------------------------------------
call dein#add('tpope/vim-fugitive')
call dein#add('jreybert/vimagit', {'on_cmd': 'Magit'})

augroup fugitive_config
  autocmd!
  autocmd FileType gitcommit setl cursorline
augroup END

"- Navigation
"--------------------------------------------------
call dein#add('scrooloose/nerdtree')
call dein#add('ctrlpvim/ctrlp.vim')

let NERDTreeShowHidden = 1
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

nnoremap <silent> <Leader>ne :NERDTreeToggle<CR>

"- Completion, snippets and alike
"--------------------------------------------------
call dein#add('Shougo/deoplete.nvim')
call dein#add('Raimondi/delimitMate')
call dein#add('SirVer/ultisnips')
call dein#add('mattn/emmet-vim', {'on_ft': ['html', 'blade']})
call dein#add('Shougo/neco-vim', {'on_ft': 'vim', 'depends': 'deoplete.nvim'})

set completeopt=menu,menuone,noinsert,noselect
let g:deoplete#enable_smart_case = 1

" `g:deoplete#enable_at_startup` causes a huge lag when first entering insert mode.
augroup deoplete_startup
  autocmd!
  autocmd VimEnter * call deoplete#enable()
augroup END

function! Multiple_cursors_before()
  let b:deoplete_disable_auto_complete = 2
endfunction

function! Multiple_cursors_after()
  let b:deoplete_disable_auto_complete = 0
endfunction

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

augroup fix_delimitMate_in_php_files
  autocmd!
  autocmd FileType php let b:delimitMate_matchpairs = '(:),[:],{:}'
augroup END

let g:UltiSnipsExpandTrigger='<Tab>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

"- Language support
"--------------------------------------------------
call dein#add('tpope/vim-endwise', {'on_ft': ['vim', 'sh', 'zsh', 'ruby']})
call dein#add('othree/html5.vim', {'on_ft': ['html', 'blade']})
call dein#add('gregsexton/MatchTag', {'on_ft': ['html', 'blade']})
call dein#add('hail2u/vim-css3-syntax', {'on_ft': ['css', 'scss']})
call dein#add('keith/tmux.vim', {'on_ft': 'tmux'})
call dein#add('elzr/vim-json', {'on_ft': 'json'})
call dein#add('othree/yajs.vim', {'on_ft': 'javascript'})
call dein#add('othree/es.next.syntax.vim', {'on_ft': 'javascript', 'depends': 'yajs.vim'})
call dein#add('othree/jsdoc-syntax.vim', {'on_ft': 'javascript'})
call dein#add('heavenshell/vim-jsdoc', {'on_ft': 'javascript'})
call dein#add('StanAngeloff/php.vim', {'on_ft': 'php'})

let g:vim_json_syntax_conceal = 0

let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_param_description_separator = ' - '
let g:jsdoc_tags = {'returns': 'return'}

if executable('tern')
  call dein#add('ternjs/tern_for_vim', {'on_ft': 'javascript'})
  call dein#add('carlitux/deoplete-ternjs', {'on_ft': 'javascript', 'depends': 'deoplete.nvim'})

  let g:tern_request_timeout = 1
  let g:tern_map_keys = 1
  let g:tern_show_signature_in_pum = 1
  let g:tern#command = ['tern']
  let g:tern#arguments = ['--persistent']
endif

"- Framework support
"--------------------------------------------------
call dein#add('jwalton512/vim-blade', {'on_ft': 'blade'})
call dein#add('noahfrederick/vim-composer', {'on_cmd': 'Composer'})
call dein#add('tpope/vim-dispatch', {'on_cmd': 'Console'})
call dein#add('tpope/vim-projectionist', {
  \ 'on_cmd': ['Econtroller', 'Eview'],
  \ 'on_source': 'vim-dispatch'})
call dein#add('noahfrederick/vim-laravel', {
  \ 'on_cmd': 'Artisan',
  \ 'on_map': 'gf',
  \ 'on_source': ['vim-dispatch', 'vim-projectionist']})

"- User interface
"--------------------------------------------------
call dein#add('chriskempson/base16-vim')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

let base16colorspace = 256

if ! filereadable(expand('~/.vimrc_background'))
  colorscheme desert
else
  source ~/.vimrc_background
  augroup override_colors
    autocmd!
    autocmd ColorScheme * highlight! link Search CursorLine
  augroup END
endif

set noshowmode
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers= 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline_theme = 'base16_oceanicnext'
let g:airline_section_z = '%{g:airline_symbols.linenr} %l:%v [%p%%|%L]'

"- Dein footer
call dein#end()

"= Post-plugin fixes {{{1
"==================================================
filetype plugin on

augroup force_options
  autocmd!
  autocmd BufReadPost * setl formatoptions-=o
augroup END
