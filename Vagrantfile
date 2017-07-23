# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_check_update = true
  config.vm.provision :shell, path: "install.sh", privileged: false
  config.vm.synced_folder ".", "/home/ubuntu/workspace"
  # config.vm.network "forwarded_port", guest: "port", host: port
  config.ssh.forward_agent = true
end
