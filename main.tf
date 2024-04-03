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
  profie                  = "default"
}

provider "google" {
  project                 = "inft-1209-lab5"
  region                  = "us-central1"
  zone                    = "us-central1-a"
}

provider "azure" {
  features {}
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}