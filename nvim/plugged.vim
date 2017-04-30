"= Dein header
"==================================================
set runtimepath+=$XDG_DATA_HOME/dein.vim/repos/github.com/Shougo/dein.vim/
call dein#begin($XDG_DATA_HOME.'/dein.vim')
call dein#add('Shougo/dein.vim')
call dein#add('haya14busa/dein-command.vim')

"= Basic features
"==================================================
call dein#add('editorconfig/editorconfig-vim')
call dein#add('pbrisbin/vim-mkdir')
call dein#add('dkprice/vim-easygrep')
call dein#add('nelstrom/vim-visual-star-search')
call dein#add('tpope/vim-repeat')
call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-unimpaired')
call dein#add('tomtom/tcomment_vim')
call dein#add('terryma/vim-multiple-cursors')

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"= Code quality
"==================================================
call dein#add('w0rp/ale')

let g:ale_set_signs = 0
let g:ale_echo_msg_format = '[%linter%] %s'

"= Source control
"==================================================
call dein#add('tpope/vim-fugitive')
call dein#add('jreybert/vimagit', {'on_cmd': 'Magit'})

augroup fugitive_config
  autocmd!
  autocmd FileType gitcommit setl cursorline
augroup END

"= Navigation
"==================================================
call dein#add('scrooloose/nerdtree')
call dein#add('ctrlpvim/ctrlp.vim')

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let NERDTreeShowHidden = 1

nnoremap <silent> <Leader>ne :NERDTreeToggle<CR>

"= Completion, snippets and alike
"==================================================
call dein#add('Shougo/deoplete.nvim')
call dein#add('Raimondi/delimitMate')
call dein#add('SirVer/ultisnips')
call dein#add('mattn/emmet-vim', {'on_ft': ['html', 'blade']})
call dein#add('Shougo/neco-vim', {'on_ft': 'vim', 'depends': 'deoplete.nvim'})

set completeopt=menu,menuone,noinsert,noselect
let g:deoplete#enable_smart_case = 1

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

augroup fix_delimitMate_in_php_files
  autocmd!
  autocmd FileType php let b:delimitMate_matchpairs = '(:),[:],{:}'
augroup END

let g:UltiSnipsExpandTrigger='<Tab>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

"= Language support
"==================================================
call dein#add('tpope/vim-endwise', {'on_ft': ['vim', 'sh', 'zsh', 'ruby']})
call dein#add('othree/html5.vim', {'on_ft': ['html', 'blade']})
call dein#add('gregsexton/MatchTag', {'on_ft': ['html', 'blade']})
call dein#add('hail2u/vim-css3-syntax', {'on_ft': ['css', 'scss']})
call dein#add('whatyouhide/vim-tmux-syntax', {'on_ft': ['tmux', 'tmux-conf']})
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

"= Framework support
"==================================================
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

"= User interface
"==================================================
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

"= Dein footer
"==================================================
call dein#end()
