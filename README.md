## Prerequisites

* Kubectl : client (1.17), server (1.17)
* Helm 2.16.1
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
```
vagrant@127.0.0.1's password: vagrant

## Kubernetes Dashboard

* https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

```sh
# Install, only one time
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
$ kubectl apply -f kubernetes/dashboard/install.yaml

# Run the dashboard
$ ./kubernetes/dashboard/run.sh
```

## Kubernetes Istio

```sh
# Download Istio
$ curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.3.4 sh -
$ cd istio-1.3.4
$ export PATH=$PWD/bin:$PATH

# Install Tiller in Kubernetes
$ kubectl apply -f install/kubernetes/helm/helm-service-account.yaml
$ helm init --service-account tiller
$ cd ..

# Initialize istio
$ kubectl apply -f kubernetes/istio/tillerNodePort.yaml
$ export HELM_HOST=192.168.50.11:32492

# Initialize istio
$ cd istio-1.3.4
$ helm install install/kubernetes/helm/istio-init --name istio-init --namespace istio-system --set pilot.resources.requests.memory="512Mi"
$ helm install install/kubernetes/helm/istio --name istio --namespace istio-system --set gateways.istio-ingressgateway.type=NodePort --set gateways.istio-egressgateway.type=NodePort --set enable-validation=true  --values install/kubernetes/helm/istio/values-istio-demo.yaml
$ kubectl label namespace default istio-injection=enabled
$ cd ..

# Install some services
$ kubectl apply -f kubernetes/istio/services.yaml
```

* Prometheus: http://192.168.50.11:32494
* Jaeger: http://192.168.50.11:32495
* Grafana: http://192.168.50.11:32493
* Kiali: http://192.168.50.11:32496/kiali/console (Use admin/admin)

## Check Istio Installation

```sh
$ kubectl get all -A
```

## Copyrights

* https://www.itwonderlab.com/ansible-kubernetes-vagrant-tutorial
* https://www.itwonderlab.com/installing-istio-in-kubernetes-under-virtualbox
* https://github.com/ITWonderLab/ansible-vbox-vagrant-kubernetes
