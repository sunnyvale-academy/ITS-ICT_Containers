# Install Linux 

## Prerequisites

Having installed all the softwares listed in [Prerequisites](../00-Prerequisites/README.md).

This lab assumes that you have a bash terminal and your PWD is the directory where this README.md file is located.


## Setup Vagrant plugins

```console
$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-reload
$ vagrant plugin install vagrant-hostmanager
```

## Start Ubuntu Linux installation

```console
$ cd vagrant/ubuntu
$ vagrant up
```

## Start a Fedora Linux installation


```console
$ cd vagrant/fedora
$ vagrant up
```

## Vagrant tips

Please note that the `vagrant up` command can be used in the future to simply start the VM (without reinstalling it).

Other useful Vagrant commands are:

- `vagrant halt`: stops the VM. You have to run this command in the directory where the Vagrantfile is located. 

- `vagrant destroy`: destrois the VM. You have to run this command in the directory where the Vagrantfile is located. 
