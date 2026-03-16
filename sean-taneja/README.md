# prehire-task-go-client
Repository used for pre hire task on k8s go-client

## NamespaceWatcher
NamespaceWatcher is a GoLang application designed to watch for namespace events in Kubernetes clusters. It creates and manages roles and role bindings based on user access configuration. It gets the user access configuration from the ConfigMap deployed on the Kubernetes Cluster

## How to run it locally (without docker)
* Download and install Go
* go mod download
* go build -o main .
* export KUBECONFIG=${KUBECONFIG_PATH}
* ./main 

## How to run tests
* go test -coverprofile=coverage.out
* go tool cover -func=coverage.out (to check code coverage)

## How to install with Helm chart
* Build Docker
* cd helm
* helm package .
* helm install prehire-demo-go-app ./prehire-demo-go-app-0.1.0.tgz

