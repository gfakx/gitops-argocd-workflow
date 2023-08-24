terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

  }



  #  AZURE_SUBSCRIPTION_ID = var.AZURE_SUBSCRIPTION_ID
  #  AZURE_CLIENT_ID       = var.AZURE_CLIENT_ID
  #  AZURE_CLIENT_SECRET   = var.AZURE_CLIENT_SECRET
  #  AZURE_TENANT_ID       = var.AZURE_TENANT_ID
}
