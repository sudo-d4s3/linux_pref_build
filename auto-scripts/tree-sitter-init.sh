#!/bin/sh
#downloading tree-sitter-cli
wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.20.7/tree-sitter-linux-x64.gz
gzip -d tree-sitter-linux-x64.gz
ln -s $PWD/tree-sitter /home/$USER/.local/bin/
rm -rf tree-sitter-linux-x64.gz

#setting up parser location
mkdir tree-sitter-parsers && pushd tree-sitter-parsers

#setting up parsers
git clone https://github.com/tree-sitter/tree-sitter-c
git clone https://github.com/tree-sitter/tree-sitter-python
git clone https://github.com/alemuller/tree-sitter-make    
git clone https://github.com/ikatyang/tree-sitter-markdown
#no nim parsers :(



