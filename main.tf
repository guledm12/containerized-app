variable "location" {
  type    = string
  default = "East US"
}

variable "containerized_apps" {
  type = list(object({
    image = string
    name = string
    tag = string
    containerPort = number
    ingress_enabled = bool
    min_replicas = number
    max_replicas = number
    cpu_requests = number
    mem_requests = string
  }))

  default = [{
   image = "gmohamed/app"
   name = "application1"
   tag = "app1"
   containerPort = 80
   ingress_enabled = true
   min_replicas = 1
   max_replicas = 2
   cpu_requests = 0.5
   mem_requests = "1.0Gi"
  },
  {
   image = "gmohamed/app"
   name = "application2"
   tag = "app2"
   containerPort = 80
   ingress_enabled = true
   min_replicas = 1
   max_replicas = 2
   cpu_requests = 0.5
   mem_requests = "1.0Gi"
  }] 
}
terraform {
  required_providers {
    azurerm = {
    }
    azapi = {
      source = "Azure/azapi"
      version = "~>0.4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}

resource "azurerm_resource_group" "rg" {
  name     = "containerized-app"
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-aca-terraform-containerized-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}