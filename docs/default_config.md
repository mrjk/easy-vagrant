# Default configuration

There is a dump of the default configuration:

```
---
settings:
  defaults:
    flavor: tiny
    box: centos7
    provider: libvirt
    prefix: prefix-
    sufix: "-sufix"
    provisionners: {}
  flavors:
    nano:
      cpu: '1'
      memory: '128'
      disk: '5'
    micro:
      cpu: '2'
      memory: '512'
      disk: '10'
    small:
      cpu: '2'
      memory: '1024'
      disk: '10'
    medium:
      cpu: '2'
      memory: '2048'
      disk: '20'
    large:
      cpu: '3'
      memory: '4096'
      disk: '30'
    xlarge:
      cpu: '4'
      memory: '8192'
      disk: '40'
  boxes:
    debian8: wholebits/debian8-64
    debian7: wholebits/debian7-64
    ubuntu1604: wholebits/ubuntu16.10-64
    ubuntu1404: wholebits/ubuntu14.04-64
    centos7: wholebits/centos7
    centos6: wholebits/centos5-64
    archlinux: wholebits/arch-64
  providers:
    libvirt:
      settings:
        driver: nil
        host: nil
        connect_via_ssh: nil
        username: nil
        password: nil
        id_ssh_key_file: "~/.ssh/id_rsa"
        socket: nil
        uri: nil
    virtualbox:
      instances:
        linked_clones: 'true'
        execution_cap: '50'
        page_fusion: 'on'
        cpuhotplug: 'on'
        pae: 'on'
        largepages: 'on'
        guestmemoryballoon: '128'
      boxes:
        debian8: minimal/jessie64
        debian7: minimal/wheezy64
        ubuntu1604: minimal/xenial64
        ubuntu1404: minimal/trusty64
        centos7: minimal/centos7
        centos6: minimal/centos6
    docker:
      settings:
        force_host_vm: 'false'
        pull: 'false'
        remains_running: 'true'
        stop_timeout: '30'
      boxes:
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
provisionners:
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
```
