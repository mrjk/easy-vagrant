# Easy-Vagrant

Easy-vagrant is a vagrant configuration file under steroids. It mainly resolve dome problematics to spin up very quickly one or many base OS instance. It's is mainly a tool for devops then.

The goal is to be able to spinup very quickly some base OS. à la docker, but with your favorite provider.



----------

[TOC]

## Features
- Multi provider support:
	- Libvirt
	- VirtualBox
	- Docker (comming)
- Easy configuration with yaml
	- Comes with nifty defaults
	- Allow a developper configuration
	- Allow final user to ovverrides some settings to its local environment
	- No code redondancy
- Virtually allow any providers within yaml definitions
- Comes with a preset of base images
- Everything is customizable


## Support
The following OS have been tested:

- fedora23 with libvirt
- macos x Mountain Lion with VirtualBox

## Release

Initial version:


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


## Usage

## Internal

The vagrant definition is should be exclusively done with yaml. You should not have to modify the ```Vagratnfile``` unless you want to debug or add new features. The configuration is split in 3 main sources:

1. Default config: This is the hardcoded configuration. It comes with some handy defaults, such as provisionners and preset boxes for vagrant providers. You should never have to modify this configuration. Source: ```Vagrantfile```
2. Developper config: This is the configuration made by the developper of this Vagrant setup. It should mainly define the instance settings, and some provisionners. Source file: ```conf/vagrant.yml```
0. User config: This config is optional and allow the final user to ovverrides some settings according to its local computer. This configuration is outside of the git repository. Source: ```local.yml```

The default configuration inherits configuration to developper configuraiton, and user configuration inherits all configurations.

### Internal vs exposed configuration

In way to make a friendly editable yaml configuration, there were the need of exposing an easy yaml structure for the end user, and a more computer readable configuration for vagrant. The process is the following:

0. The user defines a yaml confikguration with 3 primary keys:
	1. ```settings```:
	2. ```instances```: This is literraly 
	3. ```provisionners```:


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

## License

This code is licensed under the ....

