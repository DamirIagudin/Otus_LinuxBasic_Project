# -*- mode: ruby -*-
# vi: set ft=ruby :


  Vagrant.configure("2") do |config|
	(1..2).each do |i|
		config.vm.define "linux-spec-#{i}" do |spec|
			spec.vm.box = "ubuntu/jammy64"
			spec.vm.box_version = "20230802.0.0"
			spec.vm.box_download_insecure=true
			spec.vm.box_check_update = false
			spec.vm.network "public_network", ip: "192.168.178.1#{i}"
			spec.vm.hostname = "linux-spec-#{i}"
			spec.vm.provider "virtualbox" do |vb|
				vb.memory = "4096"
				vb.cpus = "2"
				vb.name = "linux-spec-#{i}"
			end
		end
	end
end