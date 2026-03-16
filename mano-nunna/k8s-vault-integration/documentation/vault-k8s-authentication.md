# Configure Vault for Kubernetes Authentication

This guide outlines the steps to configure Vault for Kubernetes authentication, allowing Vault to authenticate users and services within a Kubernetes cluster.

## Prerequisites
- Hashi Vault should be running in k8s.
- Vault pods should be unsealed.
- Consul pods should be up and running.

```bash
export VAULT_SKIP_VERIFY=true
export VAULT_ADDR='https://vault.local'
```
These commands can be executed inside or outside the Vault pod.
### 1. Enable Kubernetes Authentication in Vault
First, enable the Kubernetes authentication method in Vault:

```bash
kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh
vault auth enable kubernetes
vault auth list
```
### 2. Configure Kubernetes Authentication
Configure the Kubernetes authentication method by providing the Kubernetes API server address, the CA certificate, and the service account token reviewer JWT:

```bash
export SA_JWT_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
export SA_CA_CRT=$(cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt)
KUBERNETES_PORT_443_TCP_ADDR=<Kubernetes API Server Address>

vault write auth/kubernetes/config \
  token_reviewer_jwt="$SA_JWT_TOKEN" \
  kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
  kubernetes_ca_cert="$SA_CA_CRT"

vault auth list
vault read auth/kubernetes/config
```
### 3. Create a Vault Policy
Define a Vault policy to specify accessible paths and capabilities for Kubernetes service accounts:

``` bash
vault policy write bimo-policy bimo-policy.hcl
vault policy read bimo-policy
```
### 4. Create a Kubernetes Role
Map the Vault policy to Kubernetes service accounts by creating a role:
```bash
vault write auth/kubernetes/role/bimo \
  bound_service_account_names=bimo-sa \
  bound_service_account_namespaces=default \
  policies=bimo-policy \
  ttl=8h
vault read auth/kubernetes/role/bimo
```
### 5. Create a Service Account in Kubernetes
Deploy a service account in Kubernetes that will be used for authentication between Kubernetes and Vault:
```bash
kubectl apply -f bimo-sa.yaml
```
### 6. Write Secrets to Vault
Enable secrets and write key-value pairs:
```bash
vault secrets enable -path=secret kv-v2
vault secrets enable -path=bimo kv-v2
vault kv put secret/bimo/config username="<...>" password="<....>"
vault kv put secret/bimo/username db_username='<....>'
vault kv put secret/bimo/password db_password='<....>'

vault kv list secret/
vault kv get secret/bimo/username
vault kv get secret/bimo/password
```
### 7. Deploy an Application with the Service Account
Finally, deploy your application with the service account that has permissions to authenticate with Vault:
```bash
kubectl apply -f bimo-deployment.yaml
kubectl get pods -l app=bimo
kubectl exec -it $(kubectl get pod -l app=bimo -o jsonpath="{.items[0].metadata.name}") -- env
```
### 8. Check Secrets
Verify the secrets are correctly configured:

```bash
kubectl exec \
  $(kubectl get pod -l app=bimo -o jsonpath="{.items[0].metadata.name}") \
  -c bimo -- cat /vault/secrets/database-config.txt
  ```