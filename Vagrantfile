# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

	# basebox stuff
	config.vm.box = "ubuntu/trusty64"
	config.vbguest.auto_update = true

	# hostname and private IP -- CHANGE THE IP TO SOMETHING ELSE
	config.vm.network :private_network, ip: "10.11.12.86"
	
	# Ensure this matches your domain in group_vars/all
	# config.vm.hostname = "api.ami.local"
	config.vm.hostname = "ami.local"
	config.hostsupdater.aliases = ["api.ami.local"]

	# vbox specific config
	config.vm.provider "virtualbox" do |v|
		v.name = "AMI Default"
		v.memory = 1024
	end

	# Sync ami files for editing
	config.vm.synced_folder "ami-code", "/var/www",owner: "vagrant", group: "www-data", mount_options: ["dmode=775,fmode=775"]

	# INSTALL STUFF HERE
	config.vm.provision "ansible" do |ansible|
		ansible.verbose = "v"
		ansible.playbook = "setup.yml"
	end

end
