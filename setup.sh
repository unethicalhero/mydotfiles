#!/bin/bash
set -e

REPO_URL="https://github.com/unethicalhero/mydotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

echo "Cloning or updating dotfiles repo..."

if [ -d "$DOTFILES_DIR/.git" ]; then
  echo "Repo already exists, pulling latest changes..."
  git -C "$DOTFILES_DIR" pull
else
  echo "Cloning repo..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

echo "Running install_apps.sh..."
bash "$DOTFILES_DIR/install_apps.sh"

echo "Running copy_configs.sh..."
bash "$DOTFILES_DIR/copy_configs.sh"

echo "Bootstrap completed!"
