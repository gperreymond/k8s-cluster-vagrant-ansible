#!/bin/bash

# Create the configuration directory
mkdir -p ~/.kube

# Mount the VMs
vagrant up

# Find the SSH port of the k8s-m-1 server
vagrant port k8s-m-1

# Copy the file using scp (ssh password is vagrant)
sshpass -p 'vagrant' scp -P 2222 vagrant@127.0.0.1:/home/vagrant/.kube/config ~/.kube/config

# Kubernetes: Installing Tiller
helm init
kubectl create serviceaccount --namespace kube-system tiller
sleep 1m # sleep until started (todo)
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
sleep 1m # sleep until started (todo)
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
sleep 1m # sleep until started (todo)
helm init --service-account tiller --upgrade

# Helm: Install "Metal Load Balancer"
helm upgrade metallb --namespace metallb-system --install kubernetes/metallb --values kubernetes/metallb-values.yaml

# Helm: Install "Nginx Ingress"
helm upgrade nginx-ingress --namespace nginx-system --install kubernetes/nginx-ingress --values kubernetes/nginx-ingress-values.yaml

# Helm: Install "Kubernetes Dashboard"
# helm install kubernetes/kubernetes-dashboard --name kubernetes-dashboard --values kubernetes/values-kubernetes-dashboard.yaml
