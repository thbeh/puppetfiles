# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
sudo /etc/init.d/iptables stop
SCRIPT


Vagrant.configure("2") do |config|
  
#  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
#  config.vm.box = "trusty64"
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"

  # consul0 ====================================================================
  config.vm.define "consul0" do |consul0|

    consul0.vm.hostname = "consul0"
    # consul0.vm.network "private_network", ip: "172.20.33.10"
    consul0.vm.network "private_network", ip: "192.168.22.200"

    consul0.vm.provision "shell", inline: $script

    consul0.vm.provision :puppet do |puppet|
      puppet.hiera_config_path = "hiera/hiera.yaml"
      puppet.manifests_path = "puppet"
      puppet.module_path    = "puppet/modules"
      puppet.manifest_file  = "server.pp"
      puppet.options = [
        # '--verbose',
        # '--debug',
      ]
    end
  end
  # end ========================================================================

  # client01  =======================================================================
  config.vm.define "client01" do |client01|
  
    client01.vm.hostname = "client01"
    # client01.vm.network "private_network", ip: "172.20.33.20"

    client01.vm.provision "shell", inline: $script

    client01.vm.provision :puppet do |puppet|
      puppet.hiera_config_path = "hiera/hiera.yaml"
      puppet.manifests_path = "puppet"
      puppet.module_path    = "puppet/modules"
      puppet.manifest_file  = "client.pp"
      puppet.options = [
        # '--verbose',
        # '--debug',
      ]
    end
  end
  # end ========================================================================

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

end


