INSTALL_DIR=$1/pack/valtermro/start
PLUGINS=(
PotatoesMaster/i3-vim-syntax
Raimondi/delimitMate
SirVer/ultisnips
StanAngeloff/php.vim
cakebaker/scss-syntax.vim
chr4/nginx.vim
chriskempson/base16-vim
editorconfig/editorconfig-vim
elzr/vim-json
hail2u/vim-css3-syntax
heavenshell/vim-jsdoc
jwalton512/vim-blade
keith/tmux.vim
mattn/emmet-vim
moll/vim-node
nelstrom/vim-visual-star-search
noahfrederick/vim-composer
noahfrederick/vim-laravel
othree/html5.vim
othree/jsdoc-syntax.vim
pangloss/vim-javascript
pbrisbin/vim-mkdir
scrooloose/nerdtree
tomtom/tcomment_vim
tpope/tpope-vim-abolish
tpope/vim-dispatch
tpope/vim-fugitive
tpope/vim-projectionist
tpope/vim-repeat
tpope/vim-surround
tpope/vim-unimpaired
vim-ctrlspace/vim-ctrlspace
w0rp/ale
)

mkdir -p $INSTALL_DIR 2>/dev/null
if [[ $? != 0 ]]; then
  echo "Could not create $INSTALL_DIR"
  exit 1
fi

cd $INSTALL_DIR
for plugin in "${PLUGINS[@]}"; do
  git clone https://github.com/$plugin
done

unset INSTALL_DIR
unset PLUGINS
