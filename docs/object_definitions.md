# Easy-vagrant object definitions

## Table of content
[TOC]


## Settings


### provisionner_data
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| settings | Hash | no | (inherited) | root | {settings_data} | Define the default settings of the file. | 
| provisionners | Hash | no | (default_provisionners) | root | {provisionner_id}* | Define available provisionners. | 
| instances | Hash | yes | {} | root | {instance_id}* | Define instance definitions. | 
| Key | Type | Required | Default | Context | Choices | Description | 
| type | String | yes |  | provisionner_data | Define which vagrant provisionner is used. | Define the provisionner name. | 
| priority | Integer | no | 0 | provisionner_data | 0 to 100 | Define the loading priority order. Higher is loaded first. | 
| description | String | no |  | provisionner_data |  | Set a description. This is not parsed. | 
| params | Hash | yes |  | provisionner_data |  | Set the parameters for the provisionner. Refers to the provisionner documentation to know what settings are available. | 

### settings_data
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| default | Hash | no |  | settings | {default_data} | Define the default settings of the file. | 
| flavors | Hash | no | (inherited) | settings | {flavor_id}* | Define available provisionners. | 
| boxes | Hash | no | (inherited) | settings | {box_id}* | Define instance definitions. | 
| providers | Hash | no | (inherited) | settings | {provider_id}* | 

### default_data
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| flavor | String | no | (default_flavors) | settings_data | {flavor_id} | Define default flavor. | 
| box | String | no | (default_boxes) | settings_data | {box_id} | Define default box. | 
| provider | String | no |  | settings_data | {provider_id} | Define provider | 
| prefix | String | no |  | settings_data | [a-zA-Z0-9-] | Define instance name prefix. | 
| sufix | String | no |  | settings_data | [a-zA-Z0-9-] | Define instance name suffix. | 
| provisionners | Hash | no | {} | settings_data | {provisionner_id}* | Define default provisionners. | 

## Objects


### provisionners_id
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| <id> | Hash | no |  | provisionners_def | {provisionner_data} | This creates a new provisionner. | 

### provisionner_data
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| settings | Hash | no | (inherited) | root | {settings_data} | Define the default settings of the file. | 
| provisionners | Hash | no | (default_provisionners) | root | {provisionner_id}* | Define available provisionners. | 
| instances | Hash | yes | {} | root | {instance_id}* | Define instance definitions. | 
| Key | Type | Required | Default | Context | Choices | Description | 
| type | String | yes |  | provisionner_data | Define which vagrant provisionner is used. | Define the provisionner name. | 
| priority | Integer | no | 0 | provisionner_data | 0 to 100 | Define the loading priority order. Higher is loaded first. | 
| description | String | no |  | provisionner_data |  | Set a description. This is not parsed. | 
| params | Hash | yes |  | provisionner_data |  | Set the parameters for the provisionner. Refers to the provisionner documentation to know what settings are available. | 

### box_id
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| <id> | String | no |  | box_def | Atlas ID or URL | This creates a new box, with the reference or URL of the box. | 

### flavor_id
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| <id> | Hash | no |  | flavor_def | {flavor_data} | This define a flavor. | 

### flavor_data
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| cpu | Integer | yes |  | flavor_data | 1 to N | Define instance CPU (vCPUs). | 
| memory | Integer | yes |  | flavor_data | 32 to N | Define instance memroy (RAM). | 
| disk | Integer | yes |  | flavor_data | 1 to N | Define instance disk space, in Gb. | 

### instance_id
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| <id> | Hash | no |  | instance_def | {instance_data} | Define one or more instance. | 

### instance_data
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| box | String | no | (inherited) | instance_data | {box_id} | 
| number | Integer | no | 1 | instance_data | 0 to N | Define number of instances to creates. Names are automatically incremented if number > 1. | 
| flavor | String | no | (inherited) | instance_data | {flavor_id} | Define which flavor should be used. | 
| cpu | Integer | no | (inherited) | instance_data | 1 to N | Define instance CPU (vCPUs). Override flavor. | 
| memory | Integer | no | (inherited) | instance_data | 32 to N | Define instance memroy (RAM). Override flavor. | 
| disk | Integer | no | (inherited) | instance_data | 1 to N | Define instance disk space, in Gb. Override flavor. | 
| ports | Array | no | {} | instance_data | {port_data}* | Define port mapping. This work for VirtualBox only. | 
| provisionners | Hash | no | (inherited) | instance_data | {provisionner_id}* | 

### port_data
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| guest | Integer | yes |  | port_data | 0 to 65535 | Guest port to map. 0 disable the port. | 
| host | Integer | yes |  | port_data | 0 to 65535 | Host port to map on 127.0.0.1 interface. 0 disable the port. | 
| protocol | String | no | tcp | port_data | tcp|udp | Define protocol TCP or UDP. | 

### provider_id
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| <id> | Hash | no |  | provider_def | {provider_data} | Define a provisionner | 

### provider_data
| Key | Type | Required | Default | Context | Choices | Description |
|-----|------|----------|---------|---------|---------|-------------|
| settings | Hash | no |  | provider_data |  | Global settings of the provider. Check the provider documentation. | 
| instances | Hash | no |  | provider_data |  | Settings to be applied on all instances. Check the provider documentation. | 
| boxes | Hash | no |  | provider_data | {box_id}* | Override default box id for this provider. | 

## Default


### default_flavors
| Id | cpu | memory | disk |
|----|-----|--------|------|
| micro | 1 | 128 | 10 | 
| tiny | 2 | 512 | 10 | 
| small | 2 | 1024 | 10 | 
| medium | 2 | 2048 | 10 | 
| large | 3 | 4096 | 15 | 
| huge | 4 | 8192 | 20 | 

### default_boxes
| Id | Source | Provider |
|----|--------|----------|
| debian8 | wholebits/debian8-64 | default | 
| debian7 | wholebits/debian7-64 | default | 
| ubuntu1604 | wholebits/ubuntu16.10-64 | default | 
| ubuntu1404 | wholebits/ubuntu14.04-64 | default | 
| centos7 | wholebits/centos7 | default | 
| centos6 | wholebits/centos5-64 | default | 
| arch | wholebits/arch-64 | default | 
| 
| debian8 | minimal/jessie64 | VirtualBox | 
| debian7 | minimal/wheezy64 | VirtualBox | 
| ubuntu1604 | minimal/xenial64 | VirtualBox | 
| ubuntu1404 | minimal/trusty64 | VirtualBox | 
| centos7 | minimal/centos7 | VirtualBox | 
| centos6 | minimal/centos6 | VirtualBox | 
| 
| scratch | scratch | Docker | 
| alpine | alpine:latest | Docker | 
| debian8 | debian:8 | Docker | 
| debian7 | debian:7 | Docker | 
| ubuntu1604 | ubuntu:xenial | Docker | 
| ubuntu1404 | ubuntu:trusty | Docker | 
| ubuntu1204 | ubuntu:precise | Docker | 
| centos7 | centos:7 | Docker | 
| centos6 | centos:6 | Docker | 
| centos5 | centos:5 | Docker | 
| arch | archlinuxjp/archlinux | Docker | 

### default_provisionners
| id | type | Description |
|----|------|-------------|
| test_shell_script | shell | Push a script on target | 
| test_shell_cli | shell | Execute a command on target | 
| install_python_for_ansible | shell | Install python on target | 
| test_ansible | ansible | Run an Ansible playbook | 
