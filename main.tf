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
    azurerm = {}
  }
  required_version = ">= 1.0"
}
provider "azurerm" {
  features {}
}

resource "random_integer" "sa_id" {
  min = 1000
  max = 9999
}
resource "azurerm_resource_group" "rg" {
  name     = "containerized-app"
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

#sa_name = "4sysopsstgacct6365"