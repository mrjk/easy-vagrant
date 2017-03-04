


## Table of content
[TOC]

## Installation


To run Easy-vagrant, you must have:

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

The Easy-vagrant configuration format is pretty simple, but it allows very sophisticated setups through default settings and merge strategies. We will see in this chapter the two main concepts of a Easy-vagrant configuration.

### Primary key settings
In way to make a friendly configuration in yaml, a structure has been defined with three primary keys, defined at the root of the yaml file:

1. ```settings```: There are all default settings. They default unset values.
2. ```instances```: This is the definition of all your instances
3. ```provisionners```: This is the definition of all your provisionners


> Note:
> The complete structure specifications is available in the _Settings_ section of the [object definitions](object_definitions.md#Settings) documentation.


Easy-vagrant will read all these primary key to generate an array of instances, which will be understood by Vagrant itself. The structure of these primary keys can be complicated to handle, as yaml does not provide structure for its data, so the full structure if described into the  [object definitions](object_definitions.md#Settings) documentation. You can also check out examples into the  [examples directory](examples). we will show you two configurations below.

There is an example of a minimalistic setup, and it is sufficient to have 4 VMs:
```
---
instances:
  web:
  redis:
    number: 3
    box: ubuntu1604
```

Another complete example below, but please remind you everything is optional, except the ``instances`` definitions.

```
---
settings:
  defaults:
    flavor: preprod
    box: project_box
    provider: libvirt
    provisionners:
      install_python_for_ansible:
        priority: 100
      test_shell_cli:
        priority: 70
        params:
          inline: echo "Instance ready" > /root/status
      test_ansible:
        priority: 90 
        params:
          playbook: my_own_playbook.yml
  flavors:
    mysql-prod:
      cpu: 8
      memory: 8192
      disk: 100
    mysql-preprod:
      cpu: 2
      memory: 2048
      disk: 100
    web-prod:
      cpu: 4
      memory: 4092
      disk: 10
    web-preprod:
      cpu: 2
      memory: 1024
      disk: 10
  boxes:
    project_box: http://vagrant.company.com/box/master_project.box

instances:
  web:
    number: 3
    flavor: web-preprod
  mysql:
    number: 2
    flavor: mysql-preprod
```
The default section is a list of settings applied by default to all instances. Each setting reference an existing object which is defined in other part of the configuration.


### Object definition
Easy-vagrant use objects to avoid code repetition, and it allows references to those object in some specific contexts.

- boxes: Define a box
- provisionners: Define a provisionner
- flavors: Define a flavor
- instance: Define one (or N copies) of a VM
- providers: Define a provider

> Note:
> The complete objects specifications is available in the _Object_ section of the [object definitions](object_definitions.md#Objects) documentation.


## Default configuration 
Easy-vagrant comes with some nifty defaults. They try to fit the most common cases, but if they don't fit to your needs, you can override/adjust any of them through inheritance mechanisms. We introduce here all defaults objects, and their specificities in dedicated sub sections.

> Note:
> The complete default objects specifications is available in the _Default_ section of the [object definitions](object_definitions.md#Default) documentation. You can checkout the very last specifications in the ``VagrantFile`` file source code, where the ```conf_default``` variable is defined. There is also a dump of the current default configuration in the [Default configuration](default_configuration.md) file. You can regenerate this dump by setting ``show_config_parsed`` to true``, see [hacking](#Hacking) chapter.

Easy-vagrant provides these default objects:

- Default flavors:
  - ``micro``
  - ``tiny``
  - ``small``
  - ``medium``
  - ``large``
  - ``huge``
- Default VM box (generic, might be override at provider level)
  - ``debian8``
  - ``debian8``
  - ``centos8`` 
  - ``centos8``
  - ``ubuntu1604``
  - ``ubuntu1404``
  - ``archlinux``
- Default provisionners:
  - ``test_shell_script``: Run a shell script on guest
  - ``test_shell_cli``: Run a command on guests
  - ``install_python_for_ansible``: Install python on guests
  - ``test_ansible``: Run a default playbook
- Default VM box (per providers, see the doc)

#### Provisionners
Provisionners  are not enabled by default when defined in the ``provisionners`` key. To enable them, you need to list them into the ``settings.defaults.provisionners`` key or per instance in ``instances.<instance_id>.provisionners`` key. A simple mention of the key is enough to enable them. You can obviously override them with a specific merging startegy.

#### Default Boxes    
It is important to note every provider should provide these default keys to be compatible across different setups. See the next chapter to understand in depth how per provider box works.

> Note:
> If you want to use your own boxes, and if you want to be portables across different providers, be sure you provided a compatible box for each provider.


#### Default boxes (per provider)
Some boxes are multi provider, some other not. By default, default boxes support LibVirt and VirtualBox. But sometimes we want to use a specific boxes for a specific providers, so you can override those defaults. It is especially used for the Docker support, where VM images and containers are not the same technologies. 

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
    archlinux: archlinuxjp/archlinux



## Inheritance and merging strategies

Easy-vagrant configuration can be split in three different areas, and this chapter will present how those configurations are merged (inheritance) and how you can modify its behaviour (merging strategy).

### Inheritance

The vagrant definition should be exclusively done with yaml syntax. You should not have to modify the ```Vagrantfile``` in any way unless you want to debug or add new features. The configuration is split in 3 main sources, in order of inheritance:

1. Default config: This is the hardcoded configuration. It comes with some handy defaults, such as provisionners and preset boxes for vagrant providers. You should never have to modify this configuration. Source: ```Vagrantfile```
2. Developper config: This is the configuration made by the developper of this Vagrant setup. It should mainly define the instance settings, and some provisionners. Source file: ```conf/vagrant.yml```
3. User config: This config is optional and allow the final user to ovverrides some settings according to its local computer. This configuration is outside of the git repository. Source: ```local.yml```


### Default merging strategy
By default, when two objects are present in parent and child configuration, the child configuration take precedence, unless the child key is set empty. Hashes are merged this way recursively. This is the default behaviour when no merging strategy are not set.

### Customized merging strategy
To define a merging strategy on a key, you need to create a new key at the same level with the same name appended with ``_``. No worries these keys will be deleted once parsed.

> Note:
> All the available strategy are a pretty complicated algorithm to write, and as this stage of the project, there are no unit tests. See the [hacking](#Hacking) section if you want to discover how to debug them in case of troubles.

Merge strategy:

- ``union`` (merge):  This is a simple recursive merge, child value takes precedence when non empty.
- ``replace`` (replace): Replace unconditionally the parent value.
- ``unset`` (unset): Unset the key.
- ``inherit`` (inherit): Merge only child object, discard parent objects.
- ``intersect`` (common): Keep only common objects defined in both parent in child. Other are discarded.
- ``difference`` (exclude [list]): Remove a list of objects if present in parent, the resulting list is merged (``union``) with child objects.
- ``complement`` (invert [list]): Invert a list of objects if present in parent, the resulting list is merged (``union``) with child objects only if they were present in parent.



> Note:
> The complete merge strategy specifications is available in the _Merge Strategy_ section of the [object definitions](object_definitions.md#Merge-Strategy) documentation.



As you can see, some merge strategies takes a list as parameter, so in way to make things quick to write, there are two format:

```
# First format, only available when strategy don't need options
provisionners_: replace
provisionners:
  key1: val1
  key2: val2
  ...
  

# Second format, only required when strategy needs options, with Array
provisionners_: 
  action: intersect
  options:
    - key2
provisionners:
  key1: val1
  key2: val2
  ...
  
 
# Second format, only required when strategy needs options, with Hash
provisionners_: 
  action: intersect
  options:
    key2:
provisionners:
  key1: val1
  key2: val2
  ...
  
```
It is important to note that options expect a list of key or can be directly a hash. Internally, array are converted to hash. When used with hash, there is no point to set a value to the key, as they are never parsed.


## Examples
Many examples configuration are provided into the [examples directory](examples). You just need to look these files, and copy them in place of the ``conf/vagrant.yml``. You can use them as user configuration (```local.yml```) as well, but it might not be very relevant to do that.

## Hacking

Ruby is rough, and can be difficult to debug. You may need as well to dump your configuration at some stage of the Easy-vagrant parsing. For this, there are some variables which could be switched to get an extensive dump of the current configuration. They are placed directly into the ``VagrantFile``, so you need to go into the source code to modify them, close to the top of the file:

Variables:

- ``dry_run``: Just parse the configuration, never launch Vagrant
- ``show_banner``: Show Easy-vagrant banner.
- ``show_config_merged``: This show the merging of all configurations (default, developper and user)
- ``show_config_parsed``: Show the generated configuration, once completely parsed, instances definitions included.
- ``show_config_instances``: Show only the instances configuration.


