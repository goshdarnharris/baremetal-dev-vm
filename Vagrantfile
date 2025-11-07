# -*- mode: ruby -*-
# vi: set ft=ruby :

arch = ENV["ARCH"]

#Vagrant will merge all of the defined configurations together.
require_relative "ssh"
require_relative "usb"
require_relative "environment"

Vagrant.configure("2") do |config|
  config.vm.define "luminbox" do |luminbox|
    luminbox.vm.box = "ubuntu/jammy64"
    luminbox.vm.disk :disk, size: "50GB", primary: true
    luminbox.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "luminbox"
      vb.memory = 8192
      vb.cpus = 2
    end

    luminbox.vm.hostname = "luminbox"
    luminbox.vm.synced_folder "./shared", "/shared",
      mount_options: ["dmode=755,fmode=644"]
  end
end
