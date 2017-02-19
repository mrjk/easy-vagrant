# -*- mode: ruby -*-
# vim: set ft=ruby  tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab :
# vi: set ft=ruby  tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab :

# Date: 2015/12/16
# Version 0.5
# License: MIT
# Author: mrjk[dot]78[at]gmail[dot]com



########################################
# Simplified vagrant architecture spwaner
########################################

# Please edit the "arch.yml" file to build your own architecture.
# Do not edit what's bellow unless you know what you do (and Ruby)
Vagrant.require_version ">= 1.7.0"
VAGRANTFILE_API_VERSION = "2"
require 'yaml'

# Debug variables
show_banner = true
show_config_merged = true
show_config_instances = true
show_config_parsed = false

########################################
# Argument parsing
########################################




########################################
# Display banner
########################################

if show_banner
  puts "===================================================="
  puts "==             Welcome on easy-vagrant            =="
  puts "==                    by mrjk                     =="
  puts "===================================================="
  puts ""
end


########################################
# Default configuration
########################################

# This is the default structure. All of this can
# be overriden into userland. Do not edit this structure
# unless you know what you do.

conf_default = {
  'settings' => {
    'defaults' => {
      'flavor' => 'tiny',
      'box' => 'centos7',
			'provider' => 'libvirt',
			'prefix' => 'prefix-',
			'sufix' => '-sufix',
			'provisionners' => {
        'test_shell_cli' => {
          'override' => 'true', 
        } },
    },
    'flavors' => {
      'micro' => {
        'cpu' => '1',
        'memory' => '128',
        'disk' => '10'
      },
      'tiny' => {
        'cpu' => '2',
        'memory' => '512',
        'disk' => '10'
      },
      'small' => {
        'cpu' => '2',
        'memory' => '1024',
        'disk' => '10'
      },
      'medium' => {
        'cpu' => '2',
        'memory' => '2024',
        'disk' => '10'
      },
      'large' => {
        'cpu' => '3',
        'memory' => '4096',
        'disk' => '10'
      },
      'huge' => {
        'cpu' => '4',
        'memory' => '8192',
        'disk' => '10'
      }
    },
    'boxes' => {
    	'debian8' => 'wholebits/debian8-64',
    	'debian7' => 'wholebits/debian7-64',
    	'ubuntu1604' => 'wholebits/ubuntu16.10-64',
    	'ubuntu1404' => 'wholebits/ubuntu14.04-64',
    	'centos7' => 'wholebits/centos7',
    	'centos6' => 'wholebits/centos5-64',
    	'arch' => 'wholebits/arch-64',
    },
    'providers' => {
      'libvirt' => {
				'driver' => 'nil',
				'host' => 'nil',
				'connect_via_ssh' => 'nil',
				'username' => 'nil',
				'password' => 'nil',
				'id_ssh_key_file' => '~/.ssh/id_rsa',
				'socket' => 'nil',
				'uri' => 'nil'
      },
      'virtualbox' => {
				'instances' => {
					'linked_clones' => 'true',
					'execution_cap' => '50',
					'page_fusion' => 'on',
					'cpuhotplug' => 'on',
					'pae' => 'on',
					'largepages' => 'on',
					'guestmemoryballoon' => '128',
        'boxes' => {
					'debian8' => 'minimal/jessie64',
					'debian7' => 'minimal/wheezy64',
					'ubuntu1604' => 'minimal/xenial64',
					'ubuntu1404' => 'minimal/trusty64',
					'centos7' => 'minimal/centos7',
					'centos6' => 'minimal/centos6',
        }
      	},
      },
      'docker' => {
				'force_host_vm' => 'false',
				'pull' => 'false',
				'remains_running' => 'true',
				'stop_timeout' => '30',
        'boxes' => {
					'scratch' => 'scratch',
					'alpine' => 'alpine:latest',
					'debian8' => 'debian:8',
					'debian7' => 'debian:7',
					'ubuntu1604' => 'ubuntu:xenial',
					'ubuntu1404' => 'ubuntu:trusty',
					'ubuntu1204' => 'ubuntu:precise',
					'centos7' => 'centos:7',
					'centos6' => 'centos:6',
					'centos5' => 'centos:5',
					'arch' => 'archlinuxjp/archlinux'
        }
      }
		}
  },
  'provisionners' => {
    'test_shell_script' => {
      'type' => 'shell',
      'description' => 'This execute a shell script',
      'params' => {
        'path' => 'conf/shell_script_provisionning.sh',
        'args' => [
          'Provisionning',
          'shell_script',
          'worked as expected as non root.',
        ],
        'privileged' => false,
      },
    },
    'test_shell_cli' => {
      'type' => 'shell',
      'description' => 'This execute a shell command',
      'params' => {
        'inline' => 'echo $1 $2 $3 > /tmp/vagrant_provisionning_cli',
        'args' => [
          'Provisionning',
          'shell_cli',
          'worked as expected as root.',
        ],
        'privileged' => true,
      },
    },
    'test_ansible' => {
      'type' => 'ansible',
      'description' => 'This run an Ansible playbook',
      'params' => {
        'playbook' => 'conf/playbook.yml',
      },
    },
  },
}


########################################
# Define functions
########################################

# This function checks if a subelement of a
# hash exists and it is not set to the 'null'
# string. Returns a boolean.

def attribute_is_defined(object, key)

  if object.class ==  Hash and object.key?(key)
    value = object[key].to_s

    #puts "DEBUG: object" , object.class
    #puts "DEBUG: key" , value
    #puts 

    if value.casecmp("nil") != 0
      return true
    end
  end
  return false
end


# This function is used to merge recursively two arrays. The
# right array always win except when a 'nil' string is found 
# into the new value. Last point, it will remove all keys with
# the 'unset' string value. Returns the merged array.

def merge_recursively(a, b)
  a.merge(b) {|key, val_old, val_new| 

    # Check if the new value must be taken into account
    if val_new.to_s.empty? or val_new.to_s == 'nil' or val_new == {}
      key = val_old
  
    # Check if both values are hashes
    elsif val_old.class == Hash and val_new.class == Hash
      merge_recursively(val_old, val_new) 

    # Returns the newer value
		else
      key = val_new
    end

  }.delete_if { |k, v| v.to_s == 'unset' }

end


########################################
# Load and merge config settings
########################################


# Load default configuration
conf_merged = conf_default

# Load mainteneur configuration
if File.file?('conf/vagrant.yml')
	conf_merged = merge_recursively(conf_merged, YAML.load_file('conf/vagrant.yml') )
end

# Load user configuration
if File.file?('local.yml')
	conf_merged = merge_recursively(conf_merged, YAML.load_file('local.yml') )
end


if show_config_merged 
  # Dump configuration
  puts "NOTICE: This is the merged raw configuration:"
  print YAML::dump(conf_merged)
end



########################################
# Resolve configuration links
########################################

conf_final = {}


# Settings: Boxes
# =====================
conf_final['providers'] = conf_merged['settings']['providers']

# Boxes
conf_merged['settings']['providers'].each do |key, value|

  # Get common boxes
  global_boxes = conf_merged['settings']['boxes']

  # Get local provider box override
  if attribute_is_defined(value, 'boxes')
    provider_boxes = value['boxes']
  else
    provider_boxes = {}
  end

  # Update config
  conf_final['providers'][key]['boxes'] = merge_recursively(global_boxes, provider_boxes)

end



# Instances: flavors, boxes, number
# =====================
conf_final['instances'] = {}

conf_merged['instances'].each do |key, value|

  vm_config = {}


  # Manage flavors
  # =====================
 
  # Get flavor name
  if attribute_is_defined(value, 'flavor')
    # Instance flavor is set
    vm_flavor = value['flavor']
  else
    # Fall back on default flavor
    vm_flavor = conf_merged['settings']['defaults']['flavor']
  end

  # Define cpu
  if attribute_is_defined(value, 'cpu')
    vm_config['cpu'] = value['cpu']
  else
    vm_config['cpu'] = conf_merged['settings']['flavors'][vm_flavor]['cpu']
  end

  # Define memory
  if attribute_is_defined(value, 'memory')
    vm_config['memory'] = vm_config['cpu'] = value['memory']
  else
    vm_config['memory'] = conf_merged['settings']['flavors'][vm_flavor]['memory']
  end

  # Define disk
  if attribute_is_defined(value, 'disk')
    vm_config['disk'] = value['disk']
  else
    vm_config['disk'] = conf_merged['settings']['flavors'][vm_flavor]['disk'] 
  end


  # Manage flavors
  # =====================
 
  # Define box
  if attribute_is_defined(value, 'box')
    vm_config['box'] = value['box']
  else
    vm_config['box'] = conf_merged['settings']['defaults']['box'] 
  end


  # Manage provisionners
  # =====================
  
  vm_provisionners = {}

  # Try to merge default and instance providers
  if conf_merged['settings']['defaults']['provisionners'].class == Hash \
    and value['provisionners'].class == Hash

    # Merge and override default provisionners with instance provisionners
    vm_provisionners = merge_recursively( 
                            conf_merged['settings']['defaults']['provisionners'], 
                            value['provisionners'])

  elsif conf_merged['settings']['defaults']['provisionners'].class == Hash 

    # Take only default provisionners
    vm_provisionners = conf_merged['settings']['defaults']['provisionners']

  elsif value['provisionners'].class == Hash

    # Take only instance provsionners
    vm_provisionners = value['provisionners'].class == Hash

  else

    # No provisionners at all
    vm_provisionners = {}

  end


  # Merge instance provisionners with global provisionners
  vm_provisionners.each do |name, settings|

    # Check if provisionner exists
    if conf_merged['provisionners'][name].class == Hash
      # Check if we need to override object
      if settings.class != Hash
        settings = conf_merged['provisionners'][name]
      else
        settings = merge_recursively(conf_merged['provisionners'][name], settings)
      end
    end

    # Check if provisionners are correctly set
    if settings.class != Hash
      puts "ERROR: The provisionner '" + name + "' is not correclty set."
      abort
    end

    # Ensure priority attribute is defined, or defaulted to 0
    if attribute_is_defined(settings, 'priority')
      settings['priority'] = settings['priority'].to_i
    else
      settings['priority'] = 0
    end

    # Merge the config
    vm_provisionners[name] = settings

  end

  # Reverse sort provisionners
  vm_config['provisionners'] = vm_provisionners.sort_by { |name, settings| settings['priority'] }.reverse.to_h



  # Manage instance number
  # =====================
 
  # Detect how many instances
  if attribute_is_defined(value, 'number') and value['number'] > 1

    # Generate the request number of instances
    for number in 1..value['number'] do
      # TODO: Do IP increment here
      conf_final['instances'][key + number.to_s] = vm_config.clone
    end

  elsif (
      attribute_is_defined(value, 'number') \
      and value['number'] != 0 \
    ) or not attribute_is_defined(value, 'number')

    # Write config
    conf_final['instances'][key] = vm_config
  end

end


# Final configuration is ready
# =====================

# Show debugging
if show_config_instances
  puts
  puts "NOTICE: This is the instances configuration:"
  print YAML::dump(conf_final['instances'])
end

# Show debugging
if show_config_parsed
  puts
  puts "NOTICE: This is the final configuration:"
  print YAML::dump(conf_final)
end



########################################
# Magic business
########################################

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  conf_final['instances'].each do |key, value|

    # Display instance config
    # =====================
    # puts "Define instance: " + key
    # print YAML::dump(value)
    # puts ""


    # Define instance
    # =====================
    config.vm.define key do |instance|


      # Generic Instance Definition
      # =====================
      instance.vm.hostname = key

      # Disable synced folders
      instance.vm.synced_folder ".", "/vagrant", :disabled => true


      # Provisionners
      # =====================
      value['provisionners'].each do |name, settings|

        instance.vm.provision settings['type'] do |s|

          settings['params'].each do |k, v|
            s.send("#{k}=",v)

          end

          # This is what the above block dynamically do :-D
          #s.inline = settings['params']['inline']
          #s.args   = settings['params']['args']

        end
      end


      # Provider: Libvirt
      # =====================
      instance.vm.provider "libvirt" do |l, o|

        # instanceure provider
        l.cpus = value["cpu"].to_i
        l.memory = value["memory"].to_i

        # Override
        o.vm.box = conf_final['providers']['libvirt']['boxes'][value["box"]]
      end
    

      # Provider: VirtualBox
      # =====================
      instance.vm.provider "virtualbox" do |v, o|

        # instanceure provider
        v.customize ["modifyvm", :id, "--cpus", value["cpu"]]
        v.customize ["modifyvm", :id, "--memory", value["memory"]]

        # Override
        o.vm.box = conf_final['providers']['virtualbox']['boxes'][value["box"]]
      end
    

      # Provider: Docker
      # =====================
      # Note: Todo

    end

  end


end















#################### OLD DEPRECATED

#       # I do not recommand you to use virtualbox, network settings are f***ing buggy/broken ...
#       config.vm.provider "libvirt"
#       config.vm.provider "virtualbox"
#     
#     
#       # Configure default box
#       config.vm.box = "chef/centos-7.1"
#       config.vm.provider "libvirt" do |v, override|
#         override.vm.box = "dliappis/centos7minlibvirt"
#         #override.vm.box = "GeeMedia/CentOS-7.1"
#       end
#     
#     #  config.vm.provider "libvirt" do |libvirt|
#     #    libvirt.connect_via_ssh = true
#     #    libvirt.host = arch["hyp_host"]
#     #    libvirt.username = arch["hyp_username"]
#     #    libvirt.id_ssh_key_file = arch["hyp_key"]
#     #  end
#     
#     
#     # VirtualBox settings:
#       #
#       # Vagrant.configure("2") do |config|
#       #   config.vm.network "private_network", ip: "192.168.50.4",
#       #     virtualbox__intnet: "mynetwork"
#       #   config.vm.network "private_network", ip: "192.168.50.4", nic_type: "virtio"
#       # end
#       #
#       # config.vm.provider "virtualbox" do |v|
#       # 	v.name = "my_vm"
#       # 	v.linked_clone = true if Vagrant::VERSION =~ /^1.8/
#       # 	v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
#       # 	v.customize ["modifyvm", :id, "--memory", "512"]
#       # 	v.customize ["modifyvm", :id, "--pagefusion", "on"]
#       # 	v.customize ["modifyvm", :id, "--acpi", "on"]
#       # 	v.customize ["modifyvm", :id, "--cpus", "2"]
#       # 	v.customize ["modifyvm", :id, "--cpuhotplug", "2"]
#       # 	v.customize ["modifyvm", :id, "--pae", "on"]
#       # 	v.customize ["modifyvm", :id, "--largepages", "on"]
#       # 	v.customize ["modifyvm", :id, "--guestmemoryballoon", "128"]
#       # 	v.customize ["modifyvm", :id, "--pae", "on"]
#       # end
#       #
#       #
#       # Docker:
#       # Vagrant.configure("2") do |config|
#       # 	# v2 configs...
#       #
#       #   config.vm.provider "docker" do |d|
#       #   	  # Required (at least one of them)
#       #       d.image = "foo/bar"
#       #       d.build_dir = "."
#       #
#       #       # optional
#       #       build_args = 
#       #       cmd = 
#       #       create_args= 
#       #       env = 
#       #       expose = 
#       #       link = 
#       #       force_host_vm = 
#       #       pull = false
#       #       remains_running = true
#       #       stop_timeout = 30
#       #       volumes = 
#       #
#       #       email =
#       #       username =
#       #       password = 
#       #       auth_server = 
#       #       dockerfile = 
#       #
#       #   end
#       # end
#       # config.vm.provider "docker" do |d|
#       #     d.image = "vm_name of the container"
#       #       end
#       #
#       # Libvirt:
#       # memory
#       # cpus
#       # nested
#       # volume_cache = unsafe
#       # keymap = 
#       # machine_virtual_size = 20G
#       # libvirt.random :model => 'random'
#       #
#       # net config:
#       # 	:libvirt__network_name:
#       # 	:libvirt__netmask
#       # 	:libvirt__host_ip
#       # 	:libvirt__forward_mode: nat
#       # 	:libvirt__forward_device
#       # 	:libvirt__guest_ipv6: no
#       # 	:model_type = virtio
#       #
#     
#     
#       # Turn off shared folders
#       config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
#     
#     
#       # Enable ansible provisionning
#       config.vm.provision "ansible" do |ansible|
#         ansible.sudo = true
#         ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
#         #ansible.playbook = "../../deployment/rcp_deploy_arch.yml"
#         ansible.host_key_checking = false
#         ansible.playbook = arch["ansible_playbook"]
#         ansible.groups = arch["ansible_groups"]
#       end
#     
#       # Load each boxes
#       arch["boxes"].each do |name, opts|
#         config.vm.define name + arch["boxes_suffix"] do |config|
#     
#           # Define VM
#           config.vm.hostname = name + arch["boxes_suffix"]
#           config.vm.network :private_network, :ip => opts["ipaddr"], :libvirt__netmask => opts["ipnetmask"]
#     
#           # Define VM properties (LibVirt)
#           config.vm.provider "libvirt" do |l|
#             l.memory = opts["mem"]
#             l.cpus = opts["cpu"]
#           end
#     
#           # Define VM properties (VirtualBox)
#           config.vm.provider "virtualbox" do |v|
#             v.customize ["modifyvm", :id, "--memory", opts[:mem]]
#             v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
#           end
#     
#           # Change the default interface of the VM
#     #      config.vm.provision "shell", inline: "ip route delete default 2>&1 >/dev/null || true; ip route add default via " + opts["ipgateway"]
#     #      config.vm.provision "shell", inline: "sed -i 's/DEFROUTE=.*/DEFROUTE=no/' /etc/sysconfig/network-scripts/ifcfg-eth0"
#     #      config.vm.provision "shell", inline: "grep 'device=eth0' /etc/sysconfig/network-scripts/ifcfg-eth0 || echo device=eth0 >> /etc/sysconfig/network-scripts/ifcfg-eth0"
#     #      config.vm.provision "shell", inline: "grep 'DEFROUTE=yes' /etc/sysconfig/network-scripts/ifcfg-eth1 || echo DEFROUTE=yes >> /etc/sysconfig/network-scripts/ifcfg-eth1"
#     #      config.vm.provision "shell", inline: "yum remove -q -y NetworkManager || echo 'NetworkManager already removed'"
#     
#         end
#       end
#     end
#     

#
#