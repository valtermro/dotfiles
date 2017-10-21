install_dir=$1/pack/valtermro/start
plugins=(
PotatoesMaster/i3-vim-syntax
SirVer/ultisnips
StanAngeloff/php.vim
ctrlpvim/ctrlp.vim
cakebaker/scss-syntax.vim
chr4/nginx.vim
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
w0rp/ale
)

mkdir -p $install_dir 2>/dev/null
if [[ $? != 0 ]]; then
  echo "Could not create $INSTALL_DIR"
  exit 1
fi

cd $install_dir
for plugin in ${plugins[@]}; do
  echo " - ${plugin}"
  git clone --quiet --depth=1 https://github.com/$plugin
done
