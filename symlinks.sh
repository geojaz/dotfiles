#!/usr/bin/env bash
touch ~/.zshrc

# set up symlinks

ln -sf "$PWD/editor/vimrc" "$HOME/.vimrc"
ln -sf "$PWD/git/gitconfig" "$HOME/.gitconfig"
ln -sf "$PWD/git/gitignore" "$HOME/.gitignore"
ln -sf "$PWD/git/gitmessage" "$HOME/.gitmessage"

ln -sf "$PWD/shell/curlrc" "$HOME/.curlrc"
ln -sf "$PWD/shell/hushlogin" "$HOME/.hushlogin"

mkdir -p "$HOME/.config/kitty"
ln -sf "$PWD/shell/kitty.conf" "$HOME/.config/kitty/kitty.conf"

mkdir -p "$HOME/.ssh"
ln -sf "$PWD/shell/ssh" "$HOME/.ssh/config"

ln -sf "$PWD/shell/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$PWD/shell/zshrc" "$HOME/.zshrc"
ln -sf "$PWD/sql/psqlrc" "$HOME/.psqlrc"

mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$PATH"
