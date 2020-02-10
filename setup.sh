#!/bin/bash

# Create the configuration directory
mkdir -p ~/.kube

# Mount the VMs
vagrant up

# Find the SSH port of the k8s-m-1 server
vagrant port k8s-m-1

# Copy the file using scp (ssh password is vagrant)
sshpass -p 'vagrant' scp -P 2222 vagrant@127.0.0.1:/home/vagrant/.kube/config ~/.kube/config

# K8S: Installing Tiller
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
helm init --service-account tiller --upgrade

# Helm: Install "Kubernetes Dashboard"
helm install kubernetes/kubernetes-dashboard --name kubernetes-dashboard --values kubernetes/values-kubernetes-dashboard.yaml

# Helm: Install "Nginx Ingress"
helm install kubernetes/nginx-ingress --name nginx-ingress --values kubernetes/values-nginx-ingress.yaml