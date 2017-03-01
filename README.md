![Easy-vagrant logo](docs/logo.png)

Easy-vagrant is a ``Vagrantfile`` file under steroids. It mainly makes easy to design your instances with **yaml**, it **abstracts provider logic** and **reduce code duplication** for your configuration. It supports **Libvirt and VirtualBox** and can run on **most platforms**: GNU/Linux, Mac OSX and Windows. Easy-vagrant will simply ensure your configuration will run on any platform, with any provider.  


> Easy-vagrant is still in development, some features will come in future releases.


# Easy-Vagrant

As a configuration example is worth a thousand words, there is the way to spin 3 vanilla instances: 2 Centos and one deploy machine under Debian:

```
---
settings:
  defaults:
    flavor: micro
    box: centos7

instances:
  deploy:
    box: debian8
    cpu: 1
  web:
    number: 2
    ports:
      - guest: 80
        host: 8080
```
Better than Ruby syntax, nah? So, let's go into it :-)


## Quick start
To follow this quick start guide, you must ensure you have at least Vagrant and VirtualBox (or LibVirt) installed on you computer:

```
# Create your project directory from this repo
git clone https://github.com/mrjk/vagrant-skel my_project

# Go into your project
cd my_project

# Run Vagrant
vagrant up

# Tadaahhh !
```
Ok, that was pretty simple, you may want something more powerful, right? Fair enough, Easy-vagrant comes with many configurations in the [examples directory](docs/examples), or you should take a look to the documentation. See the available examples:

* Shell script provisionning
* Command execution provisionning
* Simple Ansible playbook provisionning
* Complex multi VM deployments
* Inheritance examples


## Documentation
Easy-vagrant is extensively documented. Here is the entry point of the documentation:

* Installation:
  * [Install Vagrant and VirtualBox](https://www.google.ca/search?q=How+to+install+vagrant+VirtualBox)
  * [Install Vagrant and Libvirt](https://www.google.ca/search?q=How+to+install+vagrant+libvirt)
  * Install Vagrant and Docker (comming)
* Documentation:
  * [Usage and examples](docs/usage.md)
  * [The ``vagrant.yml`` configuration](docs/configuration.md)
  * [YAML specification](docs/object_definitions.md)
  * [Default configuration](docs/default_configuration.md)
  * [Contribute](docs/developpers.md)

## Features
To let you more time to work on your project than on your development environment, Easy-vagrant comes with a lot of sexy features:

- Designed for devops:
  - Comes with nifty defaults
  - Preset of base boxes for most Linux distros
  - Provide a generic configuration
  - Everything is customizable
  - Extendable
- Simple configuration syntax:
  - Yaml syntax
  - Avoid code duplication by design
  - Global and user configuration
  - Configuration override mechanism
- Multi provider support:
  - Libvirt
  - VirtualBox
  - Docker (coming soon)
- Multi OS support:
  - GNU/Linux
  - Mac OSX
  - Windows


## Compatibility
The following OS have been tested:

- Fedora23 with LibVirt
- OSX Mountain Lion with VirtualBox
- Windows 8

If you plan to use with libvirt, you will need the following dependencies:

- fog ruby library
- [vagrant-libvirt plugin](https://github.com/vagrant-libvirt/vagrant-libvirt)


## Releases

- 0.5 - ../../..
  - Initial release

## Authors

* **[mrjk](http://jeznet.org)**: Initial work

See also the list of [contributors](https://github.com/mrjk/vagrant-skel/graphs/contributors) who participated in this project.


## Alternatives
There are not so many alternatives, but we can mention:

- [Oh-My-Vagrant](https://github.com/purpleidea/oh-my-vagrant) made by James.
- [vagrantMultiHost](https://github.com/juliangut/vagrantMultiHost ) by Julian Gut.
- [Vagrant-Up](https://github.com/Mayccoll/Vagrant-Up) by Mayccoll


## Acknowledgments
The initial idea came to me when I was working for one of my customer. If I remember well, I made an initial version from the work of [Scott Lowe](http://blog.scottlowe.org/2016/01/14/improved-way-yaml-vagrant/). Since I lost this work into my archives, I made another version from this idea thanks to [Julian Gut](http://juliangut.com/blog/configure-vagrant-hosts-yaml). I was still unhappy with its approach, and I wanted something way much simpler (in term of files) and more powerful. Then Easy-vagrant came to life.

The Vagrant logo belong to Hashicorp and the font is [Beautiful Every Time](http://www.fontspace.com/kimberly-geswein/beautiful-every-time) made by Kimberly Geswein.

## License

Please read [GNU AFFERO GENERAL PUBLIC V3 LICENSE](LICENSE).

