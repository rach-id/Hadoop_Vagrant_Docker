Vagrant.configure("2") do |config|

	config.vm.box = "peru/ubuntu-18.04-server-amd64"
	config.vm.box_version = "20191202.01"

	def create_hadoop_host(config, hostname, ip, port1, port2)
		config.vm.define hostname do |host|
		
			host.vm.provider "virtualbox" do |vb|
				vb.gui = false
				vb.memory = 1000
				vb.cpus = 2
			end
			
			
			host.vm.hostname = hostname
			config.vm.synced_folder ".", "/vagrant"
			host.vm.provision "shell", path: "Provision/provision.sh"
			
			host.vm.network "private_network", ip: ip
			host.vm.network "forwarded_port", guest: 9870, host: port1
			host.vm.network "forwarded_port", guest: 8088, host: port2
			
		end
	end
	
	
	create_hadoop_host config, "slave1", "172.20.10.5", 9873, 8091
	create_hadoop_host config, "slave2", "172.20.10.6", 9872, 8090
	create_hadoop_host config, "master", "172.20.10.4", 9870, 8088

	
end
