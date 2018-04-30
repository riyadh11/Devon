class Devon
    def Devon.configure(config, settings)
        # Set The VM Provider
        ENV['VAGRANT_DEFAULT_PROVIDER'] = settings["provider"] ||= "virtualbox"

        # Configure Local Variable To Access Scripts From Remote Location
        scriptDir = File.dirname(__FILE__)

        # Allow SSH Agent Forward from The Box
        config.ssh.forward_agent = true

        # Configure The Box
        config.vm.define settings["name"] ||= "devon"
        config.vm.box = settings["box"] ||= "halvards/lubuntu1604"
        config.vm.box_version = settings["version"] ||= ">= 20160611.0.0"
        config.vm.hostname = settings["hostname"] ||= "devon"

        # Configure A Private Network IP
        if settings["ip"] != "autonetwork"
            config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"
        else
            config.vm.network :private_network, :ip => "0.0.0.0", :auto_network => true
        end

        # Configure Additional Networks
        if settings.has_key?("networks")
            settings["networks"].each do |network|
                config.vm.network network["type"], ip: network["ip"], bridge: network["bridge"] ||= nil, netmask: network["netmask"] ||= "255.255.255.0"
            end
        end

        # Configure A Few VirtualBox Settings
        config.vm.provider "virtualbox" do |vb|
            vb.name = settings["name"] ||= "devon"
            vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
            vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
            vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", settings["natdnshostresolver"] ||= "on"]
            vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
            if settings.has_key?("gui") && settings["gui"]
                vb.gui = true
            end
        end

        # Override Default SSH port on the host
        if (settings.has_key?("default_ssh_port"))
            config.vm.network :forwarded_port, guest: 22, host: settings["default_ssh_port"], auto_correct: false, id: "ssh"
        end

        # Standardize Ports Naming Schema
        if (settings.has_key?("ports"))
            settings["ports"].each do |port|
                port["guest"] ||= port["to"]
                port["host"] ||= port["send"]
                port["protocol"] ||= "tcp"
            end
        else
            settings["ports"] = []
        end

        # Default Port Forwarding
        default_ports = {
            80 => 8000,
            443 => 44300,
            3306 => 33060,
            4040 => 4040,
            5432 => 54320,
            8025 => 8025,
            27017 => 27017
        }

        # Use Default Port Forwarding Unless Overridden
        unless settings.has_key?("default_ports") && settings["default_ports"] == false
            default_ports.each do |guest, host|
                unless settings["ports"].any? { |mapping| mapping["guest"] == guest }
                    config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
                end
            end
        end

        # Add Custom Ports From Configuration
        if settings.has_key?("ports")
            settings["ports"].each do |port|
                config.vm.network "forwarded_port", guest: port["guest"], host: port["host"], protocol: port["protocol"], auto_correct: true
            end
        end

        # Configure The Public Key For SSH Access
        if settings.include? 'authorize'
            if File.exists? File.expand_path(settings["authorize"])
                config.vm.provision "shell" do |s|
                    s.inline = "echo $1 | grep -xq \"$1\" /home/vagrant/.ssh/authorized_keys || echo \"\n$1\" | tee -a /home/vagrant/.ssh/authorized_keys"
                    s.args = [File.read(File.expand_path(settings["authorize"]))]
                end
            end
        end

        # Copy The SSH Private Keys To The Box
        if settings.include? 'keys'
            if settings["keys"].to_s.length == 0
                puts "Check your Devon.yaml file, you have no private key(s) specified."
                exit
            end
            settings["keys"].each do |key|
                if File.exists? File.expand_path(key)
                    config.vm.provision "shell" do |s|
                        s.privileged = false
                        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
                        s.args = [File.read(File.expand_path(key)), key.split('/').last]
                    end
                else
                    puts "Check your Devon.yaml file, the path to your private key does not exist."
                    exit
                end
            end
        end

        # Copy User Files Over to VM
        if settings.include? 'copy'
            settings["copy"].each do |file|
                config.vm.provision "file" do |f|
                    f.source = File.expand_path(file["from"])
                    f.destination = file["to"].chomp('/') + "/" + file["from"].split('/').last
                end
            end
        end

        # Register All Of The Configured Shared Folders
        if settings.include? 'folders'
            settings["folders"].each do |folder|
                if File.exists? File.expand_path(folder["map"])
                    mount_opts = []

                    if (folder["type"] == "nfs")
                        mount_opts = folder["mount_options"] ? folder["mount_options"] : ['actimeo=1', 'nolock']
                    elsif (folder["type"] == "smb")
                        mount_opts = folder["mount_options"] ? folder["mount_options"] : ['vers=3.02', 'mfsymlinks']
                    end

                    # For b/w compatibility keep separate 'mount_opts', but merge with options
                    options = (folder["options"] || {}).merge({ mount_options: mount_opts })

                    # Double-splat (**) operator only works with symbol keys, so convert
                    options.keys.each{|k| options[k.to_sym] = options.delete(k) }

                    config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil, **options

                    # Bindfs support to fix shared folder (NFS) permission issue on Mac
                    if (folder["type"] == "nfs")
                        if Vagrant.has_plugin?("vagrant-bindfs")
                            config.bindfs.bind_folder folder["to"], folder["to"]
                        end
                    end
                else
                    config.vm.provision "shell" do |s|
                        s.inline = ">&2 echo \"Unable to mount one of your folders. Please check your folders in Devon.yaml\""
                    end
                end
            end
        end

        #Install Extras
        config.vm.provision "shell" do |s|
            s.name = "Installing Extras"
            s.path = scriptDir + "/install-extras.sh"
            s.privileged=false
        end

        #Install PIP Dependency
        config.vm.provision "shell" do |s|
            s.name = "Installing Python PIP"
            s.path = scriptDir + "/install-pip.sh"
            s.privileged=false
        end

        # Install Mininet
        if settings.has_key?("simulator") && settings['simulator'] == "mininet"
            config.vm.provision "shell" do |s|
                s.name = "Installing Mininet"
                s.path = scriptDir + "/install-mininet.sh"
                s.privileged=false
            end
        end

        # Install all selected controllers
        if settings.include?("controllers")
            if settings["controllers"].to_s.length == 0
                puts "Check your Devon.yaml file, you have no controller specified."
                exit
            end
            settings["controllers"].each do |controller|
                if (controller == "ryu")
                    config.vm.provision "shell" do |s|
                        s.name = "Installing Ryu"
                        s.path = scriptDir + "/install-ryu.sh"
                        s.privileged=false
                    end
                elsif (controller == "pox")
                    config.vm.provision "shell" do |s|
                        s.name ="Installing POX"
                        s.path = scriptDir + "/install-pox.sh"
                        s.privileged=false
                    end
                else
                    puts "Check your Devon.yaml file, you has specified wrong controller."
                    exit
                end
            end
        end

    end
end
