terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tempresourcenameresourcegroup"
      storage_account_name = "tempresourcenamestorageaccount"
      container_name       = "tempterraformcontainername"
      key                  = "terraform.tfstate"
      access_key           = "tempstoragekey"
  }
}

provider "azurerm" {
  subscription_id = "tempsubscriptionid"
  features {}
  client_id       = "tempclientid"
  client_secret   = "tempclientsecret"
  tenant_id       = "temptenantid"
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/temporganizationname/"
}

data "azurerm_resource_group" "exampleResourcegroup" {
  name = "tempresourcenameresourcegroup"
}