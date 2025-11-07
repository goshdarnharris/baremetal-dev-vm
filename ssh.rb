# -*- mode: ruby -*-
# vi: set ft=ruby :

arch = ENV["ARCH"]

Vagrant.configure("2") do |config|
  config.vm.define "luminbox" do |luminbox|
    
    luminbox.ssh.insert_key = false
    luminbox.ssh.private_key_path = [
      "~/.ssh/id_rsa",
      "~/.vagrant.d/insecure_private_key"
    ]

    #Add the host to the VM's authorized_keys so we can connect via normal (non-vagrant) ssh
    luminbox.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"

    #ssh forwarding doesn't seem to entirely work, so copy the host's keys over as well
    #to be used for e.g. git
    luminbox.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
    luminbox.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"

    luminbox.vm.provision "shell", name: "set-ssh-key-permissions", privileged: false, inline: <<-SHELL
      chmod 600 ~/.ssh/id_rsa
      chmod 644 ~/.ssh/id_rsa.pub
    SHELL

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
