#make dirs
mkdir ~/.config
cp .config/ ~/ -r
cd ~

#update distro
# sudo apt update && sudo apt upgrade -y
# sudo pacman -Syu
sudo xbps-install -Su

#install zsh
# sudo apt install zsh
# sudo pacman -S zsh
sudo xbps-install -S zsh

#install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#oh-my-zsh clean-up
rm .*.pre-oh-my-zsh

#oh-my-zsh config
ln -s ~/.config/.zshrc ~/.zshrc

