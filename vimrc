"= Plugins settings {{{1
"==================================================
"- built-in {{{2
"--------------------------------------------------
packadd matchit

"- chriskempson/base16-vim {{{2
"--------------------------------------------------
if filereadable(expand('~/.vimrc_background'))
  let base16colorspace = 256
  source ~/.vimrc_background
endif

augroup override_colors
  autocmd!
  autocmd ColorScheme *
    \ highlight! link Search CursorLine |
    \ highlight! Error ctermfg=9 ctermbg=none |
    \ highlight! StatusLineWarning ctermfg=9 cterm=reverse
augroup END

"- tomtom/tcomment_vim {{{2
"--------------------------------------------------
nmap gc{ mt{jgc't't

"- editorconfig/editorconfig-vim {{{2
"--------------------------------------------------
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"- tpope/vim-fugitive {{{2
"--------------------------------------------------
augroup fugitive_config
  autocmd!
  autocmd FileType gitcommit setl cursorline
augroup END

"- scrooloose/nerdtree {{{2
"--------------------------------------------------
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['.git$', 'node_modules', 'vendor']

nnoremap <silent> <leader>ne :NERDTreeToggle<CR>

"- Raimondi/delimitMate {{{2
"--------------------------------------------------
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

imap <C-g>; <C-g>g;<Esc>

augroup fix_delimitMate_in_php_files
  autocmd!
  autocmd FileType php let b:delimitMate_matchpairs = '(:),[:],{:}'
augroup END

"- SirVer/ultisnips {{{2
"--------------------------------------------------
let g:UltiSnipsExpandTrigger='<Tab>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

"- w0rp/ale {{{2
"--------------------------------------------------
let g:ale_set_signs = 0
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_linters = get(g:, 'ale_linters', {})
let g:ale_linter_aliases = get(g:, 'ale_linter_aliases', {})
let g:ale_linter_aliases.vue = ['html', 'javascript', 'scss']
let g:ale_linters.html = []
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.vue = ['eslint', 'stylelint']

"- vim-ctrlspace/vim-ctrlspace {{{2
"--------------------------------------------------
let g:CtrlSpaceCacheDir = $XDG_CACHE_HOME.'/ctrl_space'
let g:CtrlSpaceMaxHeight = 15
let g:CtrlSpaceSearchTiming = 50
let g:CtrlSpaceUseTabline = 1

nnoremap <silent> <C-Space> :CtrlSpace<CR>
nnoremap <silent> <C-p> :CtrlSpace O<CR>
nnoremap <silent> <C-t> :CtrlSpace l<CR>

highlight link CtrlSpaceSearch IncSearch

if !isdirectory(g:CtrlSpaceCacheDir)
  call mkdir(g:CtrlSpaceCacheDir, 0700)
endif

"- elzr/vim-json {{{2
"--------------------------------------------------
let g:vim_json_syntax_conceal = 0
"= endsection }}}1

"= Native settings {{{1
"==================================================
"- Basic {{{2
"--------------------------------------------------
filetype plugin indent on
syntax on

set pastetoggle=<F10>
set scrolloff=1

set splitright
set diffopt+=vertical

set foldcolumn=0
set foldlevelstart=0

augroup why_cant_i_set_it_directly?
  autocmd!
  autocmd BufReadPost * setl formatoptions-=o
augroup END

"- Stuff that should be on by default (IMHO) {{{2
"--------------------------------------------------
set hidden
set showcmd
set fileformats=unix,dos,mac
set mouse=nvc

"- Backup, undo and swap files {{{2
"--------------------------------------------------
set noswapfile
set nobackup
set nowritebackup

"- Line length control {{{2
"--------------------------------------------------
set nowrap
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
set completeopt=menuone
set wildignore+=*/tmp/*,*/node_modules/*,*/vendor/*
set wildmode=longest,list

"- Invisibles (not anymore!!) {{{2
"--------------------------------------------------
set invlist
set listchars=tab:›\ ,trail:⋅,extends:❯,precedes:❮ ",eol:¬
set showbreak=\ ❯

"- Search {{{2
"--------------------------------------------------
set ignorecase
set incsearch
set nohlsearch
set smartcase
"= endsection }}}1

"= Mappings {{{1
"==================================================
"- Fix-it Felix {{{2
"--------------------------------------------------
nnoremap ` '
nnoremap ' `
inoremap <C-c> <Esc>

"- Oh! How I hate the arrow keys! {{{2
"--------------------------------------------------
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

"- Do it again? {{{2
"--------------------------------------------------
nnoremap Q n.
nnoremap <C-q> ;.

"- "Navigating" is necessary {{{2
"--------------------------------------------------
nnoremap <C-E> 5<C-E>
nnoremap <C-Y> 5<C-Y>

nnoremap <C-O> <C-O>zz
nnoremap <C-I> <C-I>zz

"- Yank/Delete/Put {{{2
"--------------------------------------------------
" paste from the yank register
nnoremap <Space>p "0p
nnoremap <Space>P "0P
xnoremap <Space>p "0p

" copy/paste from the system's clipboard
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>y "+y
xnoremap <leader>p "+p

" strip text without overriding the unnamed register
nnoremap X "_dd
nnoremap D "_D
nnoremap S "_S
xnoremap x "_x

"- Search {{{2
"--------------------------------------------------
nnoremap / /\v
nnoremap ? ?\v

nnoremap + :set hlsearch<CR>mt*`t
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
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
set laststatus=2
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
