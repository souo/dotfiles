#!/bin/sh

if [ "$#" -lt 1 ]; then
  echo "trash - move files and folders to trash"
  echo "Usage: trash FILE|FOLDER..."
  exit 1
fi

# respect XDG_DATA_HOME if defined
if [ -n "$XDG_DATA_HOME" ]; then
  TRASH_PATH="$XDG_DATA_HOME/Trash"
else
  # fallback for Darwin and more Linux
  TRASH_PATH="$HOME/.Trash"
fi

mkdir -p "$TRASH_PATH"
for file in "$@"; do
  mv -f "$file" "$TRASH_PATH/$(basename "$file")_$(date '+%Y-%m-%d_%H%M%S')"
done
