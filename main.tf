variable "location" {
  type    = string
  default = "Canada East"
}
variable "prefix" {
  type    = string
  default = "4sysops"
}

terraform {
  required_providers {
    azurem = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }
}
provider   "azurerm"   { 
  version   =   "= 3.39.1" 
  features   {} 
} 

resource "azurerm_resource_group" "rg" {
  name     = "tfdemo-rg"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.prefix}stgacct${random_integer.sa_id.id}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

output "sa_name" {
  value = azurerm_storage_account.sa.name
}