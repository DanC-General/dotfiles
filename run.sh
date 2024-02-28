#!/bin/bash
sed -i -e 's/\r$//' git_write.sh
sed -i -e 's/\r$//' config.txt
sudo mv config.txt ~/.vimrc
sudo mv git_write.sh /usr/bin/gitc 
sudo chmod +x /usr/bin/gitc
rm run.sh