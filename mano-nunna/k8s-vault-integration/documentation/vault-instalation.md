# BiModal <> Mano Nunna - Pre-hire demo

## Setup Guide for Minikube with Consul and Vault

## Prerequisites

- Homebrew (for macOS users)
- Helm
- kubectl

## Installation Steps

### Install Minikube and Helm

```bash
brew install minikube helm
```

### Setup Minikube with KVM2 (Linux)

```bash
sudo apt update && sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y
minikube start --driver=kvm2
minikube status
kubectl get pods -A
```

### Install Consul and Vault on Minikube
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
```
### Install Consul
Create helm-consul-values.yml with the necessary configurations.
```bash
global:
  datacenter: vault-kubernetes-tutorial

client:
  enabled: true

server:
  replicas: 1
  bootstrapExpect: 1
  disruptionBudget:
    maxUnavailable: 0

```
```bash
helm install consul hashicorp/consul --values helm-consul-values.yml
```
### Install Vault
Prepare helm-vault-values.yml for Vault configurations.
```bash
server:
  affinity: ""
  ha:
    enabled: true
```
```bash
helm install vault hashicorp/vault --values manifests/helm-vault-values.yml
```

### Initialize and Unseal Vault
```bash
kubectl exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json
VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")
kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl exec vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl exec vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl exec vault-0 -- vault status
```
### Login to Vault
```bash
kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh
vault login
```
### Enable Ingress Controller in Minikube
``` minikube addons enable ingress ```
### Configure Ingress for Vault
- Create vault-ingress.yaml with your ingress resource definitions.
- Apply the Ingress resource:
``` kubectl apply -f vault-ingress.yaml```
``` kubectl get ing ```
- Update Hosts File for Vault Access
```bash
echo "$(minikube ip) vault.local" | sudo tee -a /etc/hosts
```
### login Vault and check vault status
```bash
export VAULT_SKIP_VERIFY=true
export VAULT_ADDR='https://vault.local'
vault login root
vault status
```