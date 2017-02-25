
# Easy-Vagrant

Easy-vagrant is a vagrant configuration file under steroids. It mainly resolve some problematic to spin up very quickly one or many base OS instance. It's is mainly a tool for devops then.

The goal is to be able to spinup very quickly some base OS. à la docker, but with your favourite provider (LibVirt and Vagrant).

----------

[TOC]

## Features
- Multi provider support:
  - Libvirt
  - VirtualBox
  - Docker (comming)
- Easy configuration with yaml
  - Comes with nifty defaults
  - Allow a developer configuration
  - Allow final user to overrides some settings to its local environment
  - No code redundancy
- Virtually allow any providers within yaml definitions
- Comes with a preset of base images
- Everything is customizable


## Quick start

## File structure

## Compatibility
The following OS have been tested:

- fedora23 with LibVirt
- OSx Mountain Lion with VirtualBox

If you plan to use with libvirt, you will need the following dependencies:

- fog
- vagrant-libvirt plugin

## Alternatives
There are not so many alternatives, but we can mention:

- [Oh-My-Vagrant](https://github.com/purpleidea/oh-my-vagrant) made by James.

## Contributing

To help colaborators to work on it, we assume the following convention:

* **Feat**: A new feature
* **Fix**: A bug fix
* **Change**: A behaviour
* **Docs**: Documentation only changes
* **Style**: Changes that do not affect the meaning of the code (white-space, formatting, missing
  seMi-colons, etc)
* **Refactor**: A code change that neither fixes a bug nor adds a feature
* **Clean**: A portion of legacy code
* **Perf**: A code change that improves performance
* **Test**: Adding missing or correcting existing tests
* **Chore**: Changes to the build process or auxiliary tools and libraries such as documentation
  generation


Each commit message must have a maximum lenght of 72 characters. The title must follow the imperative at the present tense. The title must start with an uppercase letter, and there is no dot at the end of the sentence. An easy way to remember is: ''if applied, this commit will <commit_title>''. Optionnaly, it is a good practice to add some explanations of what the commit do.


## Releases

- 0.5 - ../../..
  - Initial version



## License

Please read [GNU GENERAL PUBLIC LICENSE](LICENSE).

## Credits
The initial idea came to me when I was working for one of my customer. If I remember well, I made an initial version from the work of [Scott Lowe](http://blog.scottlowe.org/2016/01/14/improved-way-yaml-vagrant/). Since I lost this work into my archives, I made a new version from this idea thanks to [Julian Gut](http://juliangut.com/blog/configure-vagrant-hosts-yaml). I was still unhappy with its approach, and I wanted something way mush simpler (in term of files) and more powerful. Then easy-vagrant came to life.

Easy-vagrant is a sort of vagrant-skel, obviously made by skel (:
``` text
           .-.
 {`:      (o.O)
  \\       |~|
   \\     __|__
     o===o.=|=.o\
          .=|=. \\
          .=|=. ::}
           _=_
          ( _ )
          || ||
          || ||
          () ()
          || ||
          || ||
         ==' '==
```
Inspired from l42 work.

