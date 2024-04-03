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
  profie                  = "ec2-user"
}

provider "google" {
  project                 = "inft-1209-lab5"
  region                  = "us-central1"
  zone                    = "us-central1-a"
}

provider "azure" {
  features {}
}