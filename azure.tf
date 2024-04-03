## VPC
## -------------------------
resource "azurerm_resource_group" "vpc-network" {
  project                 = "assignment2-418411"
  name                    = "cheng-vnet"
  location                = "East US"
}