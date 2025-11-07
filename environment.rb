# -*- mode: ruby -*-
# vi: set ft=ruby :

arch = ENV["ARCH"]

Vagrant.configure("2") do |config|
  config.vm.define "luminbox" do |luminbox|
    #Always copy these, so changes to them don't require rebuilding the machine
    luminbox.vm.provision "file", run: 'always', source: "data/home/.", destination: "~"
    luminbox.vm.provision "file", run: 'always', source: "data/project-template", destination: "~/project-template"

    luminbox.vm.provision "shell", name:"git-configure-user", privileged: false, path: "scripts/guest/git-configure-user.sh", args: [`git config user.name`, `git config user.email`]
    luminbox.vm.provision "shell", name:"nix-install", path: "scripts/guest/nix-install.sh"  
    luminbox.vm.provision "shell", name:"pixi-install", privileged: false, path: "scripts/guest/pixi-install.sh"
    luminbox.vm.provision "shell", name:"direnv-install", privileged: false, path: "scripts/guest/direnv-install.sh"
    luminbox.vm.provision "shell", name:"direnv-nix-configure", privileged: false, path: "scripts/guest/direnv-nix-configure.sh"
    luminbox.vm.provision "shell", name:"change-motd", path: "scripts/guest/change-motd.sh"
  end
end
