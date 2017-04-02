filetype plugin indent on
set hidden
set nobackup
set noswapfile
set nowritebackup
set pastetoggle=<F10>
set fileformats=unix,dos,mac
set wildignore+=*/tmp/*,*/node_modules/*

set expandtab
set smartindent
set tabstop=2
set softtabstop=2
set shiftwidth=2

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

set nowrap
set textwidth=85

set ignorecase
set nohlsearch
set smartcase

" `nvim/ftdetect`??
augroup filetype_detection
  autocmd!
  autocmd BufRead,BufNewFile *.tmux set ft=tmux-conf
  autocmd BufRead,BufNewFile *.mutt set ft=muttrc
augroup END

source $XDG_CONFIG_HOME/nvim/mappings.vim
source $XDG_CONFIG_HOME/nvim/plugged.vim
