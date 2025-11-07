# -*- mode: ruby -*-
# vi: set ft=ruby :

arch = ENV["ARCH"]

Vagrant.configure("2") do |config|
  config.vm.define "luminbox" do |luminbox|
    luminbox.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--usb", "on"]
      vb.customize ["usbfilter", "add", "0", "--target", :id,
        "--name", "FTDI Dongletron UART", "--vendorid", "0x0403", "--productid", "0x6014"]
      vb.customize ["usbfilter", "add", "0", "--target", :id,
        "--name", "FTDI Dongletron JTAG", "--vendorid", "0x0403", "--productid", "0xcff8"]
    end

    luminbox.vm.provision "shell", name:"openocd-udev-group", path: "scripts/guest/openocd-udev-group.sh"
    luminbox.vm.provision "file", source: "data/60-openocd.rules", destination: "~/60-openocd.rules"

    #File provisioner can't do sudo, so we do the last part here
    luminbox.vm.provision "shell", name:"openocd-udev-rules", inline: <<-SHELL
      mv /home/vagrant/60-openocd.rules /etc/udev/rules.d/60-openocd.rules
    SHELL

    #Need this to get the FTDI kernel module, which we need for USD serial adapters
    luminbox.vm.provision "shell", name:"install-linux-modules-extra", inline: <<-SHELL
      DEBIAN_FRONTEND=noninteractive apt install -y linux-modules-extra-$(uname -r)
    SHELL
  end
end
