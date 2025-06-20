terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }
  }
}

provider "vault" {
  # Configuration options for the Vault provider
  address = "http://localhost:8200" # Replace with your Vault server address
  token   = var.vault_token
}
