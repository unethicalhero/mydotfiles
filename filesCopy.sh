#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_CONFIG_DIR="$DOTFILES_DIR/.config"
REPO_LOCAL_DIR="$DOTFILES_DIR/.local"

TARGET_CONFIG_DIR="$HOME/.config"
TARGET_LOCAL_DIR="$HOME/.local"

mkdir -p "$TARGET_CONFIG_DIR"
mkdir -p "$TARGET_LOCAL_DIR"

echo "Starting to copy config files and folders from repo .config to $TARGET_CONFIG_DIR"
echo

for item in "$REPO_CONFIG_DIR"/*; do
  name=$(basename "$item")

  read -rp "Copy config '$name' to $TARGET_CONFIG_DIR? (y/N): " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "Copying $name..."
    rsync -a "$item" "$TARGET_CONFIG_DIR/"
  else
    echo "Skipping $name"
  fi
done

echo
echo "Starting to copy files and folders from repo .local to $TARGET_LOCAL_DIR"
echo

for item in "$REPO_LOCAL_DIR"/*; do
  name=$(basename "$item")

  if [[ "$name" == "share" && -d "$item" ]]; then
    read -rp "Copy entire '.local/share' folder? (y/N): " share_answer
    if [[ "$share_answer" =~ ^[Yy]$ ]]; then
      echo "Copying entire share folder..."
      rsync -a "$item" "$TARGET_LOCAL_DIR/"
    else
      echo "Ok, selecting subfolders inside '.local/share' one by one."
      for subitem in "$item"/*; do
        subname=$(basename "$subitem")
        read -rp "Copy '.local/share/$subname'? (y/N): " sub_answer
        if [[ "$sub_answer" =~ ^[Yy]$ ]]; then
          echo "Copying '.local/share/$subname'..."
          mkdir -p "$TARGET_LOCAL_DIR/share"
          rsync -a "$subitem" "$TARGET_LOCAL_DIR/share/"
        else
          echo "Skipping '.local/share/$subname'"
        fi
      done
    fi
  else
    read -rp "Copy '$name' to $TARGET_LOCAL_DIR? (y/N): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      echo "Copying $name..."
      rsync -a "$item" "$TARGET_LOCAL_DIR/"
    else
      echo "Skipping $name"
    fi
  fi
done

echo
echo "All selected config and local files copied!"

