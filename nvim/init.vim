"= Plugged {{{1
"==================================================
"- Dein header {{{2
"--------------------------------------------------
set runtimepath+=$XDG_DATA_HOME/dein.vim/repos/github.com/Shougo/dein.vim/
call dein#begin($XDG_DATA_HOME.'/dein.vim')
call dein#add('Shougo/dein.vim')
call dein#add('haya14busa/dein-command.vim')

"- Basic features {{{2
"--------------------------------------------------
call dein#add('editorconfig/editorconfig-vim')
call dein#add('pbrisbin/vim-mkdir')
call dein#add('nelstrom/vim-visual-star-search')
call dein#add('tpope/vim-repeat')
call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-unimpaired')
call dein#add('tomtom/tcomment_vim')

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"- Completion, snippets and alike {{{2
"--------------------------------------------------
call dein#add('Shougo/deoplete.nvim')
call dein#add('Raimondi/delimitMate')
call dein#add('SirVer/ultisnips')
call dein#add('mattn/emmet-vim')
call dein#add('Shougo/neco-vim')

let g:deoplete#enable_smart_case = 1

" `g:deoplete#enable_at_startup` causes a huge lag when first entering insert mode.
augroup deoplete_startup
  autocmd!
  autocmd VimEnter * call deoplete#enable()
augroup END

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

" Raimondi/delimitMate defines a <C-g>g mapping that moves the cursor to after
" the last inserted pair, let's build upon that to append a semicolon to the line
imap <C-g>; <C-g>g;<Esc>

augroup fix_delimitMate_in_php_files
  autocmd!
  autocmd FileType php let b:delimitMate_matchpairs = '(:),[:],{:}'
augroup END

let g:UltiSnipsExpandTrigger='<Tab>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

"- Language support {{{2
"--------------------------------------------------
call dein#add('tpope/vim-endwise')
call dein#add('othree/html5.vim')
call dein#add('hail2u/vim-css3-syntax')
call dein#add('keith/tmux.vim')
call dein#add('pangloss/vim-javascript')
call dein#add('othree/jsdoc-syntax.vim')
call dein#add('elzr/vim-json')
call dein#add('moll/vim-node')
call dein#add('heavenshell/vim-jsdoc')
call dein#add('posva/vim-vue')
call dein#add('StanAngeloff/php.vim')
call dein#add('noahfrederick/vim-composer')
call dein#add('chr4/nginx.vim')
call dein#add('PotatoesMaster/i3-vim-syntax')

let g:vim_json_syntax_conceal = 0

let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_param_description_separator = ' - '
let g:jsdoc_tags = {'returns': 'return'}

if executable('tern')
  call dein#add('ternjs/tern_for_vim')
  call dein#add('carlitux/deoplete-ternjs')

  let g:tern#command = ['tern']
  let g:tern#arguments = ['--prersistent', '--no-port-file']
  let g:tern_request_timeout = 1
  let g:tern_map_keys = 1
  let g:tern_show_signature_in_pum = 1
endif

"- Framework support {{{2
"--------------------------------------------------
call dein#add('tpope/vim-dispatch')
call dein#add('tpope/vim-projectionist')
call dein#add('jwalton512/vim-blade')
call dein#add('noahfrederick/vim-laravel')

"- Code quality {{{2
"--------------------------------------------------
call dein#add('w0rp/ale')

let g:ale_set_signs = 0
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_linters = get(g:, 'ale_linters', {})
let g:ale_linter_aliases = get(g:, 'ale_linter_aliases', {})
let g:ale_linter_aliases.vue = ['html', 'javascript', 'scss']
let g:ale_linters.html = []
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.vue = ['eslint', 'stylelint']

"- Source control {{{2
"--------------------------------------------------
call dein#add('tpope/vim-fugitive')
call dein#add('jreybert/vimagit', {'on_cmd': 'Magit'})

augroup fugitive_config
  autocmd!
  autocmd FileType gitcommit setl cursorline
augroup END

"- Navigation {{{2
"--------------------------------------------------
call dein#add('scrooloose/nerdtree')
call dein#add('vim-ctrlspace/vim-ctrlspace')

let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['.git$', 'node_modules', 'vendor']

nnoremap <silent> <leader>ne :NERDTreeToggle<CR>

let g:CtrlSpaceCacheDir = $XDG_CACHE_HOME.'/ctrl_space'
let g:CtrlSpaceMaxHeight = 15
let g:CtrlSpaceSearchTiming = 50
let g:CtrlSpaceUseTabline = 1

nnoremap <silent> <C-space> :CtrlSpace<CR>
" the usual fuzzy file finder mapping
nnoremap <silent> <C-p> :CtrlSpace O<CR>
" open tab list, by default <C-t> is used with the tag stack, which I don't use so it's ok to override it
nnoremap <silent> <C-t> :CtrlSpace l<CR>

highlight link CtrlSpaceSearch IncSearch
if !isdirectory(g:CtrlSpaceCacheDir)
  call mkdir(g:CtrlSpaceCacheDir, 0700)
endif

"- Colors {{{2
"--------------------------------------------------
call dein#add('chriskempson/base16-vim')

if !filereadable(expand('~/.vimrc_background'))
  colorscheme desert
else
  let base16colorspace = 256
  source ~/.vimrc_background
endif

augroup override_colors
  autocmd!
  autocmd ColorScheme * highlight! link Search CursorLine
augroup END

"- Dein footer {{{2
"--------------------------------------------------
call dein#end()
"= endsection }}}1

"= Basic settings {{{1
"==================================================
filetype plugin indent on

"- Cursor {{{2
"--------------------------------------------------
set guicursor=
set guicursor+=n-v-c:block
set guicursor+=a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
set guicursor+=r-cr:block-blinkon0
set guicursor+=i-ci-ve:ver25
set guicursor+=o:hor50-blinkon0
set guicursor+=sm:block-blinkwait175-blinkoff150-blinkon175

"- Stuff that should be on by default (IMHO) {{{2
"--------------------------------------------------
set hidden
set number
set relativenumber
set showcmd
set fileformats=unix,dos,mac
set mouse=nvc

set pastetoggle=<F10>
set scrolloff=3

"- Backup, undo and swap files {{{2
"--------------------------------------------------
set noswapfile
set nobackup
set nowritebackup

"- Enable project-wide .nvimrc {{{2
"--------------------------------------------------
set exrc
set secure

"- Line length control {{{2
"--------------------------------------------------
set nowrap
" set textwidth=100
set colorcolumn=80

"- Indentantion {{{2
"--------------------------------------------------
set expandtab
set smartindent
set shiftwidth=2
set softtabstop=2
set tabstop=2

"- Completion {{{2
"--------------------------------------------------
set completeopt=menuone,noinsert,noselect
set wildignore+=*/tmp/*,*/node_modules/*,*/vendor/*
set wildmode=longest,list

set splitright
set diffopt+=vertical

set foldcolumn=0
set foldlevelstart=0

"- Invisibles (not anymore!!) {{{2
"--------------------------------------------------
set invlist
set listchars=tab:›\ ,trail:⋅,extends:❯,precedes:❮ ",eol:¬
set showbreak=\ ❯

"- Search {{{2
"--------------------------------------------------
set ignorecase
set nohlsearch
set smartcase

"- Undo the mess that dein.vim does {{{2
"--------------------------------------------------
augroup undo_dein_and_plugins_mess
  autocmd!

  autocmd BufReadPost * setl formatoptions-=o
augroup END
"= endsection }}}1

"= Mappings {{{1
"==================================================
"- Please, save me! {{{2
"--------------------------------------------------
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
xnoremap <C-s> <Esc>:w<CR>

"- Fix-it Felix {{{2
"--------------------------------------------------
" <C-c> is kinda like <Esc>, but in insert mode it has some quirks...
inoremap <C-c> <Esc>

" my keyboard makes it hard to type a single "`"
nnoremap ' `
nnoremap ` '

" because <C-^> is unrechable on my keyboard and <C-6> is too hard
nnoremap [<Tab> <C-^>

"- Do it again? {{{2
"--------------------------------------------------
nnoremap Q n.
nnoremap <C-q> ;.

"- "Navigating" is necessary {{{2
"--------------------------------------------------
" can't you go any faster??
nnoremap <C-E> 5<C-E>
nnoremap <C-Y> 5<C-Y>

" centralize after a jump on jumplist
nnoremap <C-O> <C-O>zz
nnoremap <C-I> <C-I>zz

" easy command history navigation
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" I prefer vertical splits (still can open horizontal splits with `<C-w>F`
nnoremap <C-w>f :vertical wincmd f<CR>

"- Yank/Delete/Put {{{2
"--------------------------------------------------
" copy/paste from the system's clipboard
nnoremap <leader>Y "+Y
nnoremap <leader>y "+y
nnoremap <leader>p "+p
xnoremap <leader>y "+y
xnoremap <leader>p "+p

" strip text without overriding the unnamed register
nnoremap X "_dd
nnoremap D "_D
nnoremap S "_S
xnoremap x "_x

"- Search {{{2
"--------------------------------------------------
" very magic search is a magic thing, don't you think?
nnoremap / /\v
nnoremap ? ?\v

" hightlight occurences of the word under the cursor
nnoremap + :set hlsearch<CR>mt*`t
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

"- Insert mode {{{2
"--------------------------------------------------
inoremap <C-g>u <Esc>gUiwea
"= endsection }}}1

"= Motions {{{1
"==================================================
" all no-blank characters in the current line
xnoremap <silent> il :<C-U>normal! g_v^<CR>
onoremap <silent> il :<C-U>normal! g_v^<CR>

" The entire line except the EOF character
xnoremap <silent> al :<C-U>normal! $v0<CR>
onoremap <silent> al :<C-U>normal! $v0<CR>

" the entire file
xnoremap <silent> af :<C-U>normal! GVgg<CR>
onoremap <silent> af :normal GVgg<CR>
"= endsection }}}1

"= Statusline {{{1
"==================================================
set statusline=
set statusline+=%([%R%H%W%{&paste?',PST':''}]%)
set statusline+=%([%{fugitive#head(7)}]%)
set statusline+=%f%-2{&mod?'*':'\ '}
set statusline+=%{StatusLineLinterInfo()}
set statusline+=%=
set statusline+=%4l:%-3v
set statusline+=%#StatusLineWarning#
set statusline+=%{StatusLineFileFormatWarning()}
set statusline+=%{StatusLineFileEncodingWarning()}
set statusline+=%{StatusLineIndentationWarning()}
set statusline+=%{StatusLineTrailingSpacesWarning()}
set statusline+=%*

augroup status_line_setup "{{{2
  autocmd!
  autocmd ColorScheme * highlight StatusLineWarning cterm=none ctermbg=66 ctermfg=52

  " update warnings when idle and after saving
  autocmd CursorHold,BufWritePost *
    \ unlet! b:statusline_indent_warning |
    \ unlet! b:statusline_trailing_spaces_warning
augroup END

" StatusLineLinterInfo() " {{{2
"--------------------------------------------------
" displays a count of errors and warnings from ALE
function! StatusLineLinterInfo()
  if winwidth(0) < 40
    return ''
  endif

  let l:count = ale#statusline#Count(bufnr('%'))
  let status = ''

  if l:count[0]
    let status .= 'E:'.l:count[0]
  endif

  if l:count[1]
    let status .= ' W:'.l:count[1]
  endif

  return l:status
endfunction

" StatusLineFileFormatWarning() {{{2
"--------------------------------------------------
" warns if the current file format is not unix
function! StatusLineFileFormatWarning()
  if &fileformat ==# 'unix'
    return ''
  endif
  return '['.&fileformat.']'
endfunction

" StatusLineFileEncodingWarning() {{{2
"--------------------------------------------------
" warns if the current file encoding is not utf-8
function! StatusLineFileEncodingWarning()
  if &fileencoding ==# '' || &fileencoding ==# 'utf-8'
    return ''
  endif
  return '['.&fileencoding.']'
endfunction

" StatusLineIndentationWarning() {{{2
"--------------------------------------------------
" warns about mixed and wrong indentation, based on the `expandtab` option
" based on https://github.com/scrooloose/vimfiles/blob/master/vimrc#L228,L248
function! StatusLineIndentationWarning()
  if !&modifiable
    return ''
  endif
  if exists('b:statusline_indent_warning')
    return b:statusline_indent_warning
  endif

  let b:statusline_indent_warning = ''
  let l:tabs = search('^\t', 'nw')
  let l:spaces = search('^ \{'.&tabstop.',}[^\t]', 'nw')

  if l:tabs && l:spaces
    let b:statusline_indent_warning = '[mixed-indent]'
  elseif (spaces && !&expandtab) || (tabs && &expandtab)
    let b:statusline_indent_warning = '[wrong-indent]'
  endif

  return b:statusline_indent_warning
endfunction

" StatusLineTrailingWarning() {{{2
"--------------------------------------------------
" based on https://github.com/scrooloose/vimfiles/blob/master/vimrc#L195,L210
function! StatusLineTrailingSpacesWarning()
  if !&modifiable || &filetype ==# 'markdown'
    return ''
  endif

  if exists('b:statusline_trailing_spaces_warning')
    return b:statusline_trailing_spaces_warning
  endif

  let b:statusline_trailing_spaces_warning = ''

  let l:trailing = search('\s\+$', 'nw')
  if l:trailing
    let b:statusline_trailing_spaces_warning = '[trailing:'.l:trailing.']'
  endif

  return b:statusline_trailing_spaces_warning
endfunction
"= endsection }}}1

"= Filetype {{{1
"==================================================
"- ftdetect {{{2
"--------------------------------------------------
augroup filetype_detect
  autocmd!
  autocmd BufRead,BufNewFile *.mutt setf muttrc
  autocmd BufRead,BufNewFile */git/* setf gitconfig

  autocmd BufRead,BufNewFile .babelrc setf json
  autocmd BufRead,BufNewFile .stylelintrc setf json
augroup END

"- ftplugin {{{2
"--------------------------------------------------
augroup filetype_plugin
  autocmd!
  autocmd FileType vim,zsh,tmux,muttrc,sh,i3 setl foldmethod=marker
  autocmd FileType vim setl keywordprg=:help
  autocmd FileType gitconfig setl noexpandtab

  autocmd FileType php setl tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType python setl tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType xml setl tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType c setl tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType go setl noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
augroup END
"= endsection }}}1
