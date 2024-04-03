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
  project                 = "assignment2-418411"
  region                  = "us-central1"
  zone                    = "us-central1-a"
}

provider "azure" {
  features {}
}