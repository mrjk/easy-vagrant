


## Table of content
[TOC]

## Installation


To run easy-vagrant, you must have:

- vagrant
  - vagrant > 1.8
  - plugins:
    - ansible
    - vagrant-libvirt
- Providers:
  - libvirt: libvirtd
  - virtualbox: virtualbox
- Provisionners:
  - ansible: ansible (any versions)







## YAML configuration overview

The Easy-vagrant configuration seems pretty simple, bu it allow very sophisticated setups. We will see in this chapter the three main concepts of a good configuration.

### Primary key settings
In way to make a friendly configuration in yaml, a structure has been defined with three primary keys:

1. ```settings```: There are all default settings. They default unset values.
2. ```instances```: This is the definition of all your instances
3. ```provisionners```: This is the definition of all your provisionners

Easy-vagrant will read all these primary key to generate an array of instances, which will be understood by vagrant itself.

### Object definition
Easy-vagrant use object to avoid code repetition, and it allow reference to those object in some specific contexts, described below.

- boxes: Define a box
- provisionners: Define a provisionner
- providers: Define a provider
- flavors: Define a flavor
- instance: Define one (or N copies) of a VM

### Configuration inheritance
TODO:

## Object definition

#### Object: box 
A box might be the simplest object, is is defined by a key, and a value:
```
  <box_key_N>: <box_name|box_url>
```

#### Object: provisionner
A provisionner object follow the following structure:

```
  <provisionners_key_N>:
    type: <string>
    description: <string>
    priority: <int>
    params: <hash>
    
```


Where:

- priority: integer 0 to 100, default to 0. Used when provisionners are merged, in way to know which one should be applied first. Optional.
- type: Must be one of Vagrant supported provsionner, such as 'shell' or 'ansible' or your_provisionner. Required
- description: Not parsed, just for you to remember what a provider do.
- params: A hash of provider parameters. Required.



#### Object: provider
TODO.


#### Object: flavor
A flavor define a set of settings for an instance:
```
<flavor_key_N>:
  cpu:
  memory:
  disk:
```


#### Object: instance
This is how is defined an instances:

```
  <instance_key_N>:
    number: <int>
    flavor: &flavor_key_N
    cpu: <int>
    memory: <int>
    disk: <int>
    ports:   (virtualbox only)
      - guest: <port on guest>
        host: <port on host>
        protocol: tcp|udp
    provisionners:
      &provisionners_key:
      <provisionners_key_N>:
      ...
```
Every parameters are optional, only key defines the instance creation. The settings are the following:

- number: Number of instance to create, default 1. If set to 0, the instance will not be created
- flavor: Override default flavor. Take an existing flavor reference.
- cpu: Override flavor CPU settings
- memory: Override flavor RAM setting
- disk: Override flavor Disk setting
- Ports: Map guest port on localhost host interface. This settings only works with VirtualBox. It takes as argument a list of hash, where:
  - guest: Is a port number on guest.
  - host: Is a port number on host. TODO: At the current time, it may pose an issue when the ```number``` setting is used.
  - protocol: Can bon ```tcp``` or ```udp```. Default:  ```tcp```
- provisionners: It contains a hash of provisionners, where the key represent a reference to an existing provisionners (if it does not exists, it will create it if enough settings are provided). 



## Configuration structure


#### ```Settings``` key
Structure:
```
defaults:
  flavor: &flavor_key_N
  box: &box_key_N
  provider: &provider_name_N
  provisionners:
    &provisionners_key:
    <provisionners_key_N>:
    ...
flavors:
  <flavor_key_N>:
  ...
boxes:
  <box_key_N>:
  ...
providers:
  <provider_name_N>:
  ...
```
The default section is a list of settings applied by default to all instances. Each setting reference an existing object in other part of the config, excepted for the provisionners key, where you can put a hash of provisisionner keys.

#### ```Instances``` key
This define an instance. You can use the following parameters:

```
instances:
  <instance_key_N>:
  ...
```


#### ```Provisionners``` key
A provsionner allow you to provision your instances. The structure is the following:

```
provisionners:
  <provisionners_key_N>:
  ...
```


## Default configuration 
Easy-vagrant comes with some nifty defaults. The full structure is available in the source code, where the ```conf_default``` variable is defined. You can also checkout a copy of this structure in yaml [here](default_config.md).

Easy-vagrant provides these defaults:

- Default flavors
- Default VM box (generic)
- Default provisionners
- Default VM box (per providers)

#### Default flavors
There are some already set flavors, you can use them or even create your own, ore even override them:

    micro:
      cpu: '1'
      memory: '128'
      disk: '10'
    tiny:
      cpu: '2'
      memory: '512'
      disk: '10'
    small:
      cpu: '2'
      memory: '1024'
      disk: '10'
    medium:
      cpu: '2'
      memory: '2024'
      disk: '10'
    large:
      cpu: '3'
      memory: '4096'
      disk: '10'
    huge:
      cpu: '4'
      memory: '8192'
      disk: '10'
      

#### Default boxes (generic)
Default box are the following:

    debian8: wholebits/debian8-64
    debian7: wholebits/debian7-64
    ubuntu1604: wholebits/ubuntu16.10-64
    ubuntu1404: wholebits/ubuntu14.04-64
    centos7: wholebits/centos7
    centos6: wholebits/centos5-64
    arch: wholebits/arch-64
    
    
It is important to note every provider should provide these default keys to be compatible across different setups.

#### Default provisionners
We present here the default providers. They are not enabled by default, you need to explicitly in the ```provisionners``` key, either in the ```default``` section, or per instance. As you can see, they are not very useful, but you may use them if you want to override them.

    test_shell_script:
      type: shell
      description: This execute a shell script
      params:
        path: conf/scripts/test_script.sh
        args:
        - Provisionning
        - shell_script
        - worked as expected as non root.
        privileged: false
    install_python_for_ansible:
      type: shell
      priority: '90'
      description: This will install Python on the target
      params:
        path: conf/scripts/install_python.sh
        privileged: true
    test_shell_cli:
      type: shell
      description: This execute a shell command
      params:
        inline: echo $1 $2 $3 > /tmp/vagrant_provisionning_cli
        args:
        - Provisionning
        - shell_cli
        - worked as expected as root.
        privileged: true
    test_ansible:
      type: ansible
      description: This run an Ansible playbook
      params:
        playbook: conf/ansible/playbook.yml


#### Default boxes (per provider)
Some box are not available for all provider. The default boxes should support at least Libvirt and VirtualBox, but sometimes we want to use specific boxes for specific providers. In this case, the default for VirtualBox is completely unecessary as default boxes already support it. We just wanted here to use minimal boxes instead the default one.

##### Default box for VirtualBox:

    debian8: minimal/jessie64
    debian7: minimal/wheezy64
    ubuntu1604: minimal/xenial64
    ubuntu1404: minimal/trusty64
    centos7: minimal/centos7
    centos6: minimal/centos6

##### Default containers for Docker:

    scratch: scratch
    alpine: alpine:latest
    debian8: debian:8
    debian7: debian:7
    ubuntu1604: ubuntu:xenial
    ubuntu1404: ubuntu:trusty
    ubuntu1204: ubuntu:precise
    centos7: centos:7
    centos6: centos:6
    centos5: centos:5
    arch: archlinuxjp/archlinux



## Configuration overriding an inheritance
The vagrant definition should be exclusively done with yaml syntax. You should not have to modify the ```Vagrantfile``` in any way unless you want to debug or add new features. The configuration is split in 3 main sources:

1. Default config: This is the hardcoded configuration. It comes with some handy defaults, such as provisionners and preset boxes for vagrant providers. You should never have to modify this configuration. Source: ```Vagrantfile```
2. Developper config: This is the configuration made by the developper of this Vagrant setup. It should mainly define the instance settings, and some provisionners. Source file: ```conf/vagrant.yml```
0. User config: This config is optional and allow the final user to ovverrides some settings according to its local computer. This configuration is outside of the git repository. Source: ```local.yml```

The default configuration inherits configuration to developper configuraiton, and user configuration inherits all configurations.

### Default inheritance behavior


### Customized inheritance behavior



#### Provisionners


## Internal



### Internal vs exposed configuration



### Loading order and inheritance

There are two special values:

- ```nil```: Mainly used to not override a inherited value. Sort of comments finally.
- ```unset```: This remove the key. You may use this when you do not want to inherits some settings from default or developper configuration. You may not need to use this, but always useful to have it in case of. Be aware: easy-vagrant expect to have keys always defined, even if they have an empty value. Dont try to unset top level keys unless you want to break easy-vagrant.


```sequence
None-->Default: provides
Default-->Developper: provides
Developper-->User: provides

Developper-->Default: nil
User-->Developper: nil
Developper->None: unset
User->None: unset

```

### Expand and override defaults settings
It is quite easy, just replace the directive with your own content. If it is a hash, it will be merged with the inherited value. Example to expand available boxes:
```
settings:
  boxes:
    mycustomboxname: mycustombox_url/mycustombox_atlas_id
```
To overrides, there is a trick, we need to declare two times the children, the firest one with the unset value, and another time with the new content:
```
settings:
  boxes: unset
  boxes:
    mycustomboxname: mycustombox_url/mycustombox_atlas_id
```

