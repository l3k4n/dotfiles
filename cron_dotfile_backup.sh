TEMP_DIR=$(mktemp -d)

if [ ! -d "$TEMP_DIR" ]; then
  echo "Failed to create temp directory"
  exit 1
fi

cd $TEMP_DIR

git clone git@github.com:l3k4n/dotfiles.git
cd dotfiles/files

cp ~/.config/nvim/ . -rf
cp ~/.local/share/wallpapers/ -rf .
cp ~/.tmux.conf . -f
cp ~/.gitconfig . -f

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
if [ $(git diff --name-only | wc -l) -gt 0 ]; then
    git add -A
    git commit -m "auto-commit: $TIMESTAMP"
    git push
fi
