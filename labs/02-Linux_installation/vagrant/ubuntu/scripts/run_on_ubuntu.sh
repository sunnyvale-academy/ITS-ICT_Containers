sudo sed -i 's/^# deb/deb/g' /etc/apt/sources.list
sudo apt-get update && sudo apt-get upgrade -y
sudo loadkeys it
sudo apt-get install -y gnome-session gdm3
sudo sed -i 's/XKBLAYOUT=\"us\"/XKBLAYOUT=\"it\"/g' /etc/default/keyboard
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11