#!/bin/bash

# Usage:
#
# ./sync_obsidian.sh         # Copies from remote to local (default)
# ./sync_obsidian.sh --reverse  # Copies from local to remote
# Usage:
# ./sync_obsidian.sh         # Copies from remote to local (default)
# ./sync_obsidian.sh --reverse  # Copies from local to remote

# Optional --reverse flag to copy local → remote instead of remote → local
hostport=$(ngrok api endpoints list | jq -r '.endpoints[0].hostport')
host=$(echo "$hostport" | cut -d: -f1)
port=$(echo "$hostport" | cut -d: -f2)
diego="diego"

remote_path="~/Documents/Obsidian Vault/FolderX"
local_path="$HOME/Documents/Obsidian Vault/FolderX"
shared_path="$HOME/code/shared/obsidian"

mkdir -p "$local_path"

if [ "$1" == "--reverse" ]; then
  echo "Copying from local to remote..."
  scp -P "$port" "$shared_path"/*.md "$user@$host:$remote_path/"
else
  echo "Copying from remote to local..."
  scp -P "$port" "$user@$host:$remote_path/*.md" "$shared_path/"
  ln -sf "$shared_path"/* "$local_path/"
fi
