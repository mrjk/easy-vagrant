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

# Internal variables
show_banner = true
show_config_merged = false
show_config_instances = true
show_config_parsed = false



########################################
# Display banner
########################################

if show_banner
  puts "INFO: ===================================================="
  puts "INFO: ==             Welcome on easy-vagrant            =="
  puts "INFO: ==                    by mrjk                     =="
  puts "INFO: ===================================================="
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
      'provisionners' => {},
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
        'path' => 'conf/scripts/test_script.sh',
        'args' => [
          'Provisionning',
          'shell_script',
          'worked as expected as non root.',
        ],
        'privileged' => false,
      },
    },
    'install_python_for_ansible' => {
      'type' => 'shell',
      'priority' => '90',
      'description' => 'This will install Python on the target',
      'params' => {
        'path' => 'conf/scripts/install_python.sh',
        'privileged' => true,
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
        'playbook' => 'conf/ansible/playbook.yml',
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


# This function is used to merge recursively two hashes. The
# right array always win except when a '*_unset' key is found 
# into the new value. If a '*_replace' key is found, the old
# hash will be discarded.  Last point, it will remove all keys with
# the 'unset' string value. Returns the merged array.

def merge_recursively(h, o)
  # h for hash, and o for overriding hash

  merge_string = '_'

  # Check if both objects are hashes
  if h.class == Hash and o.class == Hash
    h.merge(o) {|key, val_old, val_new|

      # Check if there is an action key and options
      if o.has_key? (key + merge_string)
        if o[key + merge_string].class == String
          action = o[key + merge_string]
        elsif o[key + merge_string].class == Hash

          # Check requested action
          if o[key + merge_string].has_key? ("action") and o[key + merge_string]["action"].class == String
            action = o[key + merge_string]["action"]
          else
            action = 'merge'
            print "WARN: The action key require to be a string (key: ", key , merge_string , ".action)\n"
          end

          # Check action options
          if o[key + merge_string].has_key? ("options")
            options = o[key + merge_string]["options"]
          else
            options = nil
          end

        end
      else
        action = "merge"
        options = nil
      end

      # This is for debugging ...
      #print "====> Work on key: ", key, " (", action ,") \n== OLD (", val_old.class ,") : ", YAML::dump(val_old), "\n== NEW (" , val_new.class ,") : " , YAML::dump(val_new) , "\n\n"
      #print "====> Work on key: ", key, " (", action ,") \n== OLD (", val_old.class ,") : ", val_old, "\n== NEW (" , val_new.class ,") : " , val_new , "\n\n"

      # Let's do it
      case action

      when 'replace'
        # Replace all elements
        val_new

      when 'unset'
        # Remove all elements
        nil

      when 'merge'
        # Merge all elements

        if val_new.class == Hash and val_old.class == Hash
          merge_recursively(val_old, val_new)
        else
          # Keep old value if newer is not set
          if val_new == nil
            val_old
          else
            val_new
          end
        end

      when 'intersect'
        # Keep common elements

        if val_new.class == Hash and val_old.class == Hash
          val_new.keep_if { |k, v| val_old.key? k }
        else
          # Keep old value if newer not set
          if val_new == nil
            val_old
          else
            val_new
          end
        end

      when 'complement'
        # Keep all elements, except those listed

        if val_new.class == Hash and val_old.class == Hash
          t = merge_recursively(val_old, val_new)
          # Retrieve options
          if options.class ==Hash
            t.delete_if { |k, v| options.key? k }
          elsif options.class == Array
            t.delete_if { |k, v| options.include? k }
          else
            t
            print "WARN: Complement action require a Hash or an Array as options (key: ", key , merge_string , ".options)\n"
          end
        else
          val_old
        end

      when 'difference'
        # Remove common elements, keep uniques

        if val_new.class == Hash and val_old.class == Hash
          # Check options type
          if options.class ==Hash
            tn = val_new.select { |k, v| not options.key? k }
            to = val_old.select { |k, v| not options.key? k }
          elsif options.class == Array
            tn = val_new.select { |k, v| not options.include? k }
            to = val_old.select { |k, v| not options.include? k }
          else
            tn = val_new
            to = val_old
            print "WARN: Difference action require a Hash or an Array as options (key: ", key , merge_string , ".options)\n"
          end
          merge_recursively(tn, to)
        else
          val_new
        end

      else
        print "ERROR: Action '", action ,"'not implemented (key: ", o + "." + key + merge_string , "options)\n"
      end
    }.delete_if {|k, v| k.end_with?('_')}

  else
    o
  end

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
#


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

  # Manage ports
  # =====================
  vm_config['ports'] = []
  if attribute_is_defined(value, 'ports')

    value['ports'].each do |port|

      if port.has_key?('guest') and port.has_key?('host') \
       and port['guest'].to_i > 0 and port['host'].to_i > 0

        # TODO: Check if port is already defined/used and warn user

        p = {}
        p['guest'] = port['guest'].to_i
        p['host'] = port['host'].to_i

        if port.has_key?('protocol') \
          and ( port['protocol'] == 'tcp' or port['protocol'] == 'udp' )

          p['protocol'] = port['protocol']

        else
          p['protocol'] = 'tcp'
        end

        vm_config['ports'].push(p)

      end
    end
  end


 


  # Manage provisionners
  # =====================
  
  vm_provisionners = {}


  # Detect which provisionners should be applied on instance
  if value.has_key?('provisionners_unset')
    vm_provisionners = {}
  elsif value.has_key?('provisionners_replace')
    vm_provisionners = value['provisionners']
  elsif value['provisionners'].class == Hash
    vm_provisionners = merge_recursively(
      conf_merged['settings']['defaults']['provisionners'],
      value['provisionners'])
  else
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

          # TODO: Make this called one time at the end for Ansible

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
        l.nested = true
        l.volume_cache = 'none'
        l.keymap = 'en-us'

        # Override
        o.vm.box = conf_final['providers']['libvirt']['boxes'][value["box"]]

        # open network ports
        value['ports'].each do |port|
          o.vm.network 'forwarded_port', guest: port['guest'], host: port['host'], protocol: port['protocol'], auto_correct: true
        end

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
