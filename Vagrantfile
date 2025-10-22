# -*- mode: ruby -*-
# vi: set ft=ruby :

arch = ENV["ARCH"]

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.disk :disk, size: "50GB", primary: true
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.name = "embedded-build"
    vb.memory = 8192
    vb.cpus = 2
  end
  config.vm.hostname = "embedded-build.vm"
  config.vm.synced_folder "./shared", "/shared"
  
  # In the future we could consider using a provisioner like puppet/chef/ansible; I think they make
  # managing these pieces easier.

  #Always copy these, so changes to them don't require rebuilding the machine
  config.vm.provision "file", run: 'always', source: "flake.nix", destination: "~/flake.nix"
  config.vm.provision "file", run: 'always', source: "project-template", destination: "~/project-template"

  config.vm.provision "shell", name:"nix-install", path: "scripts/nix-install.sh"  
  config.vm.provision "shell", name:"pixi-install", privileged: false, path: "scripts/pixi-install.sh"
  config.vm.provision "shell", name:"direnv-install", privileged: false, path: "scripts/direnv-install.sh"
  config.vm.provision "shell", name:"direnv-nix-configure", privileged: false, path: "scripts/direnv-nix-configure.sh"

  config.vm.provision "shell", name:"change-motd", path: "scripts/change-motd.sh"
end
