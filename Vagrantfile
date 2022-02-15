# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "devbox" do |dev|
      dev.vm.box = "krec/ubuntu2004-x64"
      dev.vm.box_version = "0.0.2"
      dev.vm.box_download_insecure = true

	  dev.vm.provider "virtualbox" do |vb|
	    vb.gui = true
	    vb.cpus = 4
        vb.memory = 11342
		# more customization options here: https://www.virtualbox.org/manual/ch08.html
	    vb.customize ["modifyvm", :id, "--monitorcount", "1"]
	    vb.customize ["modifyvm", :id, "--audio", "none"]
		vb.customize ["modifyvm", :id, "--vram", "128"]
		vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"] # fix fucked up DNS if you move your host into VPN
	  end

	  dev.vm.network "private_network", ip: "192.168.56.3"
	  
	  # do update and upgrade
	  dev.vm.provision "shell", inline: "sudo apt-get update && sudo apt-get upgrade -y"
	  
	  # sync ansible files in vm
	  dev.vm.synced_folder "ansible", "/vagrant/ansible"

	  # run provisioning script
	  dev.vm.provision "shell", inline: <<-SHELL
		#execute ansible with roles given via commandline: ROLES="<role1>,<role2>" vagrant up
		echo "===================================="
		echo "ROLES: #{ENV['ROLES']}"
		echo "===================================="
		su vagrant -c "cd /vagrant/ansible && ansible-playbook -v #{ENV['ROLES']}"
		SHELL
	  
  end
end
