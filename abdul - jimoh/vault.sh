#!/bin/bash

# Function to install Docker if it's not installed
install_docker() {
  if ! [ -x "$(command -v docker)" ]; then
    echo "Docker is not installed. Installing Docker..."
    # Update the package list
    sudo apt-get update
    
    # Install necessary packages
    sudo apt-get install \
      ca-certificates \
      curl \
      gnupg \
      lsb-release -y
    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    
    echo "Docker installed successfully."
  else
    echo "Docker is already installed."
  fi
}

# Function to start Docker if not running
start_docker() {
  if ! pgrep -x "dockerd" > /dev/null; then
    echo "Starting Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker service started."
  else
    echo "Docker service is already running."
  fi
}

# Pull the Vault Docker image
pull_vault_image() {
  echo "Pulling Vault Docker image..."
  docker pull vault:1.13.3
  echo "Vault Docker image pulled."
}

# Run the Vault container
run_vault_container() {
  echo "Running the Vault container..."
  docker run --rm --cap-add=IPC_LOCK \
    -e 'VAULT_LOCAL_CONFIG={"storage": {"file": {"path": "/vault/file"}}, "listener": [{"tcp": { "address": "0.0.0.0:8200", "tls_disable": true}}], "default_lease_ttl": "168h", "max_lease_ttl": "720h", "ui": true}' \
    -p 8200:8200 --name=vault -d vault:1.13.3
  echo "Vault container is running."
}

# Unseal Vault
unseal_vault() {
  CONTAINER_ID=$(docker ps -qf "name=vault")
  VAULT_ADDR="http://127.0.0.1:8200"
  
  # Initialize Vault and capture the output
  INIT_OUTPUT=$(docker exec "$CONTAINER_ID" vault operator init -address=$VAULT_ADDR)

  # Extract the first three unseal keys from the output
  UNSEAL_KEY_1=$(echo "$INIT_OUTPUT" | grep 'Unseal Key 1:' | awk '{print $4}')
  UNSEAL_KEY_2=$(echo "$INIT_OUTPUT" | grep 'Unseal Key 2:' | awk '{print $4}')
  UNSEAL_KEY_3=$(echo "$INIT_OUTPUT" | grep 'Unseal Key 3:' | awk '{print $4}')

  # Output the unseal keys for reference (optional)
  echo "Unseal Key 1: $UNSEAL_KEY_1"
  echo "Unseal Key 2: $UNSEAL_KEY_2"
  echo "Unseal Key 3: $UNSEAL_KEY_3"

  # Unseal Vault using the first three unseal keys
  docker exec "$CONTAINER_ID" vault operator unseal -address=$VAULT_ADDR "$UNSEAL_KEY_1"
  docker exec "$CONTAINER_ID" vault operator unseal -address=$VAULT_ADDR "$UNSEAL_KEY_2"
  docker exec "$CONTAINER_ID" vault operator unseal -address=$VAULT_ADDR "$UNSEAL_KEY_3"

  # Output a message indicating the process is complete
  echo "Vault unsealed successfully!"
}

# Main function to execute all steps
main() {
  install_docker
  start_docker
  pull_vault_image
  run_vault_container
  sleep 10 # Give the container some time to start up
  unseal_vault
}

# Execute the main function
main
