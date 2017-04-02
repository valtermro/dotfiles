"= Setup and reset
"=================================================
let mapleader = ' '
let maplocalleader = ','

nnoremap ' `
nnoremap ` '

"= Repeating
"==================================================
" use `nmap` so tpope's vim-repeat can operate here
nmap Q n.

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
nnoremap x "_x
nnoremap D "_D
nnoremap S "_S

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
