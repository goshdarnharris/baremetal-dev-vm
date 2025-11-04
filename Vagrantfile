# -*- mode: ruby -*-
# vi: set ft=ruby :

arch = ENV["ARCH"]

Vagrant.configure("2") do |config|
  config.vm.define "luminbox" do |luminbox|
    luminbox.vm.box = "ubuntu/jammy64"
    luminbox.vm.disk :disk, size: "50GB", primary: true
    luminbox.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "luminbox"
      vb.memory = 8192
      vb.cpus = 2

      vb.customize ["modifyvm", :id, "--usb", "on"]
      vb.customize ["usbfilter", "add", "0", "--target", :id,
        "--name", "FTDI Dongletron UART", "--vendorid", "0x0403", "--productid", "0x6014"]
      vb.customize ["usbfilter", "add", "0", "--target", :id,
        "--name", "FTDI Dongletron JTAG", "--vendorid", "0x0403", "--productid", "0xcff8"]
    end

    luminbox.vm.hostname = "luminbox.vm"
    luminbox.vm.synced_folder ".", "/shared",
      mount_options: ["dmode=755,fmode=644"]

    luminbox.ssh.insert_key = false
    luminbox.ssh.private_key_path = [
      "~/.ssh/id_rsa",
      "~/.vagrant.d/insecure_private_key"
    ]
    luminbox.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
    luminbox.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
    luminbox.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"

    luminbox.vm.provision "shell", privileged: false, inline: <<-SHELL
      chmod 600 ~/.ssh/id_rsa
      chmod 644 ~/.ssh/id_rsa.pub
    SHELL
    
    # In the future we could consider using a provisioner like puppet/chef/ansible; I think they make
    # managing these pieces easier.

    #Always copy these, so changes to them don't require rebuilding the machine
    luminbox.vm.provision "file", run: 'always', source: "home/.", destination: "~"
    luminbox.vm.provision "file", run: 'always', source: "project-template", destination: "~/project-template"

    luminbox.vm.provision "shell", name:"nix-install", path: "scripts/guest/nix-install.sh"  
    luminbox.vm.provision "shell", name:"pixi-install", privileged: false, path: "scripts/guest/pixi-install.sh"
    luminbox.vm.provision "shell", name:"direnv-install", privileged: false, path: "scripts/guest/direnv-install.sh"
    luminbox.vm.provision "shell", name:"direnv-nix-configure", privileged: false, path: "scripts/guest/direnv-nix-configure.sh"
    luminbox.vm.provision "shell", name:"git-configure-user", privileged: false, path: "scripts/guest/git-configure-user.sh", args: [`git config user.name`, `git config user.email`]
    luminbox.vm.provision "shell", name:"change-motd", path: "scripts/guest/change-motd.sh"

    # Windows host configuration to make ssh simpler
    luminbox.trigger.after :up do |trigger|
      trigger.name = "Update Hosts File"
      trigger.run = {inline: ["powershell.exe -ExecutionPolicy Bypass -File ./scripts/host/update-hosts.ps1"]}
    end

    luminbox.trigger.after :up do |trigger|
      trigger.name = "Configure & Start SSH Agent"
      trigger.run = {inline: ["powershell.exe -ExecutionPolicy Bypass -File ./scripts/host/ssh-agent.ps1"]}
    end
  end
end
