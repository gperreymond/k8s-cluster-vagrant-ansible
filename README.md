## Prerequisites

* Vagrant 2.2.7
* VirtualBox 6.1
* Ansible 2.5.1

## Kubernetes Network Overview

![Overview](./ansible-kubernetes-vagrant-tutorial-Overview.png)

## Running

```sh
# Mount the VMs
$ vagrant up

# Create the configuration directory
$ mkdir -p ~/.kube

# Find the SSH port of the k8s-m-1 server
$ vagrant port k8s-m-1

# Copy the file using scp (ssh password is vagrant)
$ scp -P 2222 vagrant@127.0.0.1:/home/vagrant/.kube/config ~/.kube/config

vagrant@127.0.0.1's password: vagrant
```

## COPYRIGHTS

* https://www.itwonderlab.com/ansible-kubernetes-vagrant-tutorial
* https://github.com/ITWonderLab/ansible-vbox-vagrant-kubernetes
