#!/bin/bash
BOOKMARKS=("Documents" "Music" "Pictures" "Videos" "Downloads")

for BOOKMARK in "${BOOKMARKS[@]}"; do
mkdir -p ~/$BOOKMARK

cat >> ~/.config/gtk-3.0/bookmarks << EOF
file:///home/$USER/$BOOKMARK $BOOKMARK
EOF
done
