TEMP_DIR=$(mktemp -d)

if [ ! -d "$TEMP_DIR" ]; then
  echo "Failed to create temp directory"
  exit 1
fi

echo $TEMP_DIR
cd $TEMP_DIR

git clone git@github.com:l3k4n/dotfiles.git
cd dotfiles

cp ~/.config/nvim/ . -rf
cp ~/.local/share/wallpapers/ -rf .
cp ~/.tmux.conf . -f
cp ~/.gitconfig . -f

git diff --name-only > .changes
