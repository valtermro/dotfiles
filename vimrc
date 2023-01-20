"= Settings {{{1
"==================================================
"- Basic {{{2
"--------------------------------------------------
filetype plugin indent on
syntax on
packadd matchit

set scrolloff=1
set history=1000

set splitright
set diffopt+=vertical

set foldcolumn=0
set foldlevelstart=0

" colorscheme dark

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

"- Search {{{2
"--------------------------------------------------
nnoremap / /\v
nnoremap ? ?\v
xnoremap / /\v
xnoremap ? ?\v

nnoremap + :set hlsearch<CR>mt*`t
nnoremap - :set nohlsearch<CR>
nnoremap <silent><C-l> :<C-u>nohlsearch<CR><C-l>
"= endsection }}}1

"= Motions {{{1
"==================================================
" all non-blank characters in the current line
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
set statusline+=%f%-2{&mod?'*':'\ '}
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
