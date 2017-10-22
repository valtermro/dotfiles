install_dir=$1/pack/valtermro/start
plugins=(
PotatoesMaster/i3-vim-syntax
SirVer/ultisnips
cakebaker/scss-syntax.vim
ctrlpvim/ctrlp.vim
editorconfig/editorconfig-vim
hail2u/vim-css3-syntax
jwalton512/vim-blade
keith/tmux.vim
nelstrom/vim-visual-star-search
othree/html5.vim
othree/jsdoc-syntax.vim
pangloss/vim-javascript
pbrisbin/vim-mkdir
scrooloose/nerdtree
tomtom/tcomment_vim
tpope/tpope-vim-abolish
tpope/vim-fugitive
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
