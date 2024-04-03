## Version and configuration
## -------------------------
# terraform {
#   required_providers {
#     google = {
#       source = "hashicorp/google"
#       version = "5.22.0"
#     }
#   }
# }

provider "aws" {
  region                  = "us-east-1"
  access_key              = var.aws_access_key
  secret_key              = var.aws_secret_key
}

provider "google" {
  project                 = "inft-1209-lab5"
  region                  = "us-central1"
  zone                    = "us-central1-a"
  file                  = ".json"
}

provider "azurerm" {
  features {}
  client_id               = var.azure_client_id
  client_secret           = var.azure_client_secret
  subscription_id         = var.azure_subscription_id
  tenant_id               = var.azure_tenant_id
}