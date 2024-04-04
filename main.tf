# Version and configuration
# -------------------------
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.22.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"  # Update version to latest compatible version
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"  # Update version to latest compatible version
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  profile                 = "default"
}

provider "google" {
  project                 = "inft-1209-lab5"
  region                  = "us-central1"
  zone                    = "us-central1-a"
  credentials             = file("/home/ec2-user/inft-1209-lab5-958d04a83f34.json")
}

provider "azurerm" {
  features {}
}
