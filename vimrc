"= Plugins settings {{{1
"==================================================
"- built-in {{{2
"--------------------------------------------------
packadd matchit

"- tomtom/tcomment_vim {{{2
"--------------------------------------------------
nmap gc{ mt{jgc't't

let g:tcomment#syntax_substitute = {
  \ 'js.*': {'sub': 'javascript'},
  \ 'css.*': {'sub': 'scss'},
\ }

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
let g:NERDTreeIgnore = ['.git$', '.vagrant', 'node_modules', 'vendor']

nnoremap <silent> <leader>e :NERDTreeToggle<CR>

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

"- ctrlpvim/ctrlp.vim {{{2
"--------------------------------------------------
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
"= endsection }}}1

"= Native settings {{{1
"==================================================
"- Basic {{{2
"--------------------------------------------------
filetype plugin indent on
syntax on

set scrolloff=1
set history=1000

set splitright
set diffopt+=vertical

set foldcolumn=0
set foldlevelstart=0

if filereadable($XDG_CONFIG_HOME.'/vim/colorscheme.vim')
  exec 'source '.$XDG_CONFIG_HOME.'/vim/colorscheme.vim'
else
  colorscheme dark
endif

augroup fix_vim_overriding_my_settings
  autocmd!
  autocmd BufReadPost * setl formatoptions-=o
  autocmd FileType html,vue call s:fix_colorscheme()
augroup END

function! s:fix_colorscheme()
  highlight htmlBold cterm=none
  highlight htmlItalic cterm=none
  highlight htmlUnderline cterm=none
  highlight htmlBoldItalic cterm=none
  highlight htmlBoldUnderline cterm=none
  highlight htmlBoldUnderlineItalic cterm=none
  highlight htmlUnderlineItalic cterm=none
endfunction

"- Stuff that should be on by default (IMHO) {{{2
"--------------------------------------------------
set hidden
set showcmd
set fileformats=unix,dos,mac
set mouse=nvc
" Fix mouse inside tmux
if has('mouse_sgr')
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

"- Special files {{{2
"--------------------------------------------------
set noswapfile
set nobackup
set nowritebackup
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo

if !isdirectory($XDG_CACHE_HOME.'/vim')
  call mkdir($XDG_CACHE_HOME.'/vim', 'p', 0700)
endif

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

let g:html_indent_inctags = 'p'
let g:html_indent_autotags = 'html'

"- Completion {{{2
"--------------------------------------------------
set completeopt=menuone
set wildignore+=*/tmp/*,*/node_modules/*,*/vendor/*
set wildmode=longest,list

"- Invisibles? Not quite {{{2
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

" Keep me from doing stupid things
xnoremap u <Nop>
inoremap <C-@> <Nop>

" Make `{` and `}` jump over folded areas
" Taken (and changed to match code style) from https://superuser.com/a/1180075
" TODO: Visual mode??
function! s:paragraph_jump_over_folded(direction)
  let l:current_line = line('.')
  while foldclosed(l:current_line) != -1
    let l:current_line = search('^$', a:direction ==# 'down' ? 'Wn' : 'Wnb')
    if l:current_line == 0
      if a:direction ==# 'down'
        call cursor(line('$'), strlen(getline(line('$'))))
      else
        call cursor(1, 1)
      endif
      break
    endif
    call cursor(l:current_line, 0)
  endwhile
endfunction
nnoremap <silent>} }:call <SID>paragraph_jump_over_folded('down')<CR>
nnoremap <silent>{ {:call <SID>paragraph_jump_over_folded('up')<CR>
onoremap } :<C-u>normal }<cr>
onoremap { :<C-u>normal {<cr>

"- Basic should be basic {{{2
"--------------------------------------------------
nnoremap <space>w :w<CR>
nnoremap <space>q :q<CR>
nnoremap <space>W :wq<CR>

"- Oh! How I hate the arrow keys! {{{2
"--------------------------------------------------
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

"- Do it again? {{{2
"--------------------------------------------------
nnoremap Q ;.

"- "Navigating" is necessary {{{2
"--------------------------------------------------
nnoremap <C-E> 5<C-E>
nnoremap <C-Y> 5<C-Y>

nnoremap <C-O> <C-O>zz
nnoremap <C-I> <C-I>zz

nnoremap L $
nnoremap H _
xnoremap L $
xnoremap H _
onoremap L $
onoremap H _

" Make it easier to reach for windows and tabs commands
nnoremap [w gT
nnoremap ]w gt

nnoremap <space>- <C-w>s
nnoremap <space>i <C-w>v
nnoremap <space>k <C-w>k
nnoremap <space>l <C-w>l
nnoremap <space>j <C-w>j
nnoremap <space>h <C-w>h
nnoremap <space>o <C-w>o
nnoremap <space>= <C-w>=
nnoremap <space>_ <C-w>_
nnoremap <space>\| <C-w>\|

"- Yank/Delete/Put {{{2
"--------------------------------------------------
" paste from the yank register
nnoremap <space>p "0p
nnoremap <space>P "0P
xnoremap <space>p "0p

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
xnoremap / /\v
xnoremap ? ?\v

nnoremap + :set hlsearch<CR>mt*`t
nnoremap - :set nohlsearch<CR>
nnoremap <silent><C-l> :<C-u>nohlsearch<CR><C-l>

"- UI {{{2
"--------------------------------------------------
nnoremap <silent><leader>cl :set cursorline!<CR>
nnoremap <silent><leader>cc :set cursorcolumn!<CR>
nnoremap <silent><leader>n :setlocal number! relativenumber!<CR>
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
