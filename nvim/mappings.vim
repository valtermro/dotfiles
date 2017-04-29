"= Setup and reset
"=================================================
nnoremap ' `
nnoremap ` '

"= Dealing with buffers
"==================================================
nnoremap [3 <C-^>

"= Repeating
"==================================================
nnoremap Q n.
nnoremap <C-q> ;.

"= Resizing windows
"=================================================
nnoremap <C-Up> :resize +5<CR>
nnoremap <C-Right> :vertical resize +5<CR>
nnoremap <C-Down> :resize -5<CR>
nnoremap <C-Left> :vertical resize -5<CR>

"= Switching between windows
"=================================================
nnoremap <M-k> <C-W>k
nnoremap <M-j> <C-W>j
nnoremap <M-l> <C-W>l
nnoremap <M-h> <C-W>h

"= Avoiding arrow keys
"=================================================
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

"= Changin the UI
"=================================================
nnoremap <Leader>cul :set cursorline!<CR>

"= Code formating
"=================================================
nnoremap <Leader>= mtgg=G't

"= Stripping text
"=================================================
nnoremap X "_dd
nnoremap D "_D
nnoremap S "_S
xnoremap x "_x

"= Searching
"==================================================
nnoremap / /\v
nnoremap ? ?\v
nnoremap + :set hlsearch<CR>mt*`t
nnoremap - :set nohlsearch<CR>
nnoremap <C-l> :nohlsearch<CR>

"= Jumping around
"=================================================
nnoremap <C-E> 5<C-E>
nnoremap <C-Y> 5<C-Y>
nnoremap <C-O> <C-O>zz
nnoremap <C-I> <C-I>zz

"= Custom motions
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
