## Prerequisites

- Kubectl: client (1.17), server (1.17)
- Helm: 2.16.1
- Vagrant: 2.2.7
- VirtualBox: 6.1
- Ansible: 2.5.1
- sshpass: 1.06 (apt install)

## Helm: Install the version 2 (not 3)

```sh
# Helm 2
$ curl -L https://git.io/get_helm.sh | bash
```

Or, use the script __get_helm2.sh__ in __./utils/helm/__

## Kubernetes: Network Overview

![Overview](./ansible-kubernetes-vagrant-tutorial-Overview.png)

## Vagrant: Create master and nodes

```sh
# Create the configuration directory
$ mkdir -p ~/.kube
# Mount the VMs
$ vagrant up
# Find the SSH port of the k8s-m-1 server
$ vagrant port k8s-m-1
# Copy the file using scp (ssh password is vagrant)
$ sshpass -p 'vagrant' scp -P 2222 vagrant@127.0.0.1:/home/vagrant/.kube/config ~/.kube/config
```

## Kubernetes: Installing Tiller

```sh
$ helm init
$ kubectl create serviceaccount --namespace kube-system tiller
$ sleep 1m # sleep until started (todo)
$ kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
$ sleep 1m # sleep until started (todo)
$ kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
$ sleep 1m # sleep until started (todo)
$ helm init --service-account tiller --upgrade
```

## Kubernetes: SSL certificates

- https://kubernetes.io/docs/concepts/cluster-administration/certificates/

## Helm: Install "Kubernetes Dashboard"

- https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

## Helm: Install "Metal Load Balancer"

- https://metallb.universe.tf/configuration/calico/

```sh
$ helm upgrade metallb --namespace metallb-system --install kubernetes/metallb --values kubernetes/metallb-values.yaml
```

## Helm: Install "Nginx Ingress"

- https://kubernetes.github.io/ingress-nginx/
- https://kubernetes.io/fr/docs/concepts/services-networking/ingress/

```sh
$ helm upgrade nginx-ingress --install kubernetes/nginx-ingress --values kubernetes/nginx-ingress-values.yaml
```

## Copyrights

- https://www.dadall.info/article658/preparer-virtualbox-pour-kubernetes
- https://www.itwonderlab.com/ansible-kubernetes-vagrant-tutorial
- https://github.com/ITWonderLab/ansible-vbox-vagrant-kubernetes
