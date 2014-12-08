VAGRANTFILE_API_VERSION = "2"

require 'json'
require 'yaml'

bakeryYamlPath = File.expand_path("~/.bakery/Bakery.yaml")
afterScriptPath = File.expand_path("~/.bakery/after.sh")
aliasesPath = File.expand_path("~/.bakery/aliases")

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# Run Pre-Install Script
	if File.exists? aliasesPath then
		config.vm.provision "file", source: aliasesPath, destination: "~/.bash_aliases"
	end

	# Define The Box
	config.vm.box = "ubuntu/trusty64"
	config.vm.hostname = "bakery"
	config.ssh.pty = true

	# Ensure The Latest Version of Chef is Available
	if Vagrant.has_plugin?("vagrant-omnibus")
		config.omnibus.chef_version = "11.16.4"
		config.omnibus.install_url = 'http://www.getchef.com/chef/install.sh'
	else
		raise 'Vagrant Plugin "vagrant-omnibus" is not installed!'
	end

	# Configure Download Location for Cookbooks from Supermarket
	if Vagrant.has_plugin?("vagrant-librarian-chef")
		config.librarian_chef.cheffile_dir = "librarian"
	else
		raise 'Vagrant Plugin "vagrant-librarian-chef" is not installed!'
	end

	# Read The Bakery Configuration
	if File.exist?(bakeryYamlPath)
		settings = YAML::load(File.read(bakeryYamlPath))
	else
		raise 'Mising ~/.bakery/Bakery.yaml!'
	end

	# Configure A Private Network IP
	config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

	# Configure A Few VirtualBox Settings
	config.vm.provider "virtualbox" do |vb|
		vb.name = 'bakery'
		vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
		vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
		vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
		vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
	end

	# Configure Port Forwarding To The Box
	config.vm.network "forwarded_port", guest: 80, host: 8000
	config.vm.network "forwarded_port", guest: 443, host: 44300
	config.vm.network "forwarded_port", guest: 3306, host: 33060
	config.vm.network "forwarded_port", guest: 5432, host: 54320

	# Configure The Public Key For SSH Access
	config.vm.provision "shell" do |s|
		s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
		s.args = [File.read(File.expand_path(settings["authorize"]))]
	end

	# Copy The SSH Private Keys To The Box
	settings["keys"].each do |key|
		config.vm.provision "shell" do |s|
			s.privileged = false
			s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
			s.args = [File.read(File.expand_path(key)), key.split('/').last]
		end
	end

	# Register All Of The Configured Shared Folders
	settings["folders"].each do |folder|
		config.vm.synced_folder folder["map"], folder["to"],
			type: folder["type"],
			owner: "vagrant",
			group: "www-data",
			mount_options: ["dmode=775,fmode=664"]
	end

	# Provision The Virtual Machine Using Chef
	config.vm.provision "chef_solo" do |chef|
		chef.cookbooks_path = ["cookbooks", "librarian/cookbooks"]

		chef.json = {
			"mysql" => {"server_root_password" => "secret"},
			"postgresql" => {"password" => {"postgres" => "secret"}},
			"nginx" => {"pid" => "/run/nginx.pid"},
			"php-fpm" => {"pid" => "/run/php5-fpm.pid"},
			"databases" => settings["databases"] || [],
			"sites" => settings["sites"] || [],
			"variables" => settings["variables"] || []
		}

		chef.add_recipe "apt"
		chef.add_recipe "php"
		chef.add_recipe "php-mods::mcrypt"
		chef.add_recipe "php-fpm"
		chef.add_recipe "nginx"
		chef.add_recipe "mysql::server"
		chef.add_recipe "mysql::client"
		chef.add_recipe "postgresql::server"
		chef.add_recipe "postgresql::client"
		chef.add_recipe "composer"
		chef.add_recipe "heroku"
		chef.add_recipe "git"
		chef.add_recipe "redis"
		chef.add_recipe "memcached"
		chef.add_recipe "bakery::configure"
	end

	# Update Composer On Every Provision
	config.vm.provision "shell" do |s|
		s.inline = "/usr/local/bin/composer self-update"
	end

	# Run Post-Install Script
	if File.exists? afterScriptPath then
		config.vm.provision "shell", path: afterScriptPath
	end

end
