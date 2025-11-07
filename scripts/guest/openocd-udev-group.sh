getent group plugdev || sudo groupadd plugdev

# Add the user to the group
sudo usermod -aG plugdev vagrant
sudo usermod -aG tty vagrant
sudo usermod -aG dialout vagrant

