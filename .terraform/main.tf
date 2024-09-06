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
      resource_group_name  = data.azurerm_resource_group.exampleResourcegroup.name
      storage_account_name = data.azurerm_storage_account.exampleStorageaccount.name
      container_name       = "terraform"
      key                  = "terraform.tfstate"
      access_key           = "tempstoragekey"

      features{}
  }
}

provider "azurerm" {
  subscription_id = "tempsubscriptionid"
  features {}
  client_id       = "6cb8d31e-87f0-443c-abc6-66a8ae0a9763"
  client_secret   = "2b38Q~7FdKjSYscZMg-ib3aAABJKga~YqUAN_cYw"
  tenant_id       = "ec481362-ae50-4bfb-8524-b7c76d7b4cd8"
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/MY-ORG/"
}

# giver det mening at terraform laver project? terraform ligger i repo, men 1 project kan have flere repos, men det her kan være main repo?
# data "azuredevops_project" "exampleAzuredevopsproject" {
#   project_id = "tempazuredevopsprojectid"
#   #name               = "tempprojectname"
# }

# data "azuredevops_git_repository" "exampleAzurerepository" {
#   #id                 = "tempazurerepositoryid"
#   name               = "tempresourcenameazurerepository"
#   project_id         = data.azuredevops_project.exampleAzuredevopsproject.project_id
#   #default_branch     = "master"
# }

# data "azuredevops_branch_policy_status_check" "exampleBranchpolicy" {
#   scope {
#     match_type       = data.azuredevops_git_repository.exampleAzurerepository.default_branch
#   }
# }

# data "azuredevops_build_definition" "examplePipeline" {
#   id                 = "temppipelineid"
#   name               = "tempresourcenamepipeline"
#   project_id         = data.azuredevops_project.exampleAzuredevopsproject.project_id

#   # repository {
#   #   #repo_id     = data.azuredevops_git_repository.exampleAzurerepository.id
#   #   yml_path    = ".azure/azure-pipelines.yml"
#   #   #repo_type   = "TfsGit"
#   #   #branch_name = azuredevops_git_repository.exampleAzurerepository.default_branch
#   # }
#   #path               = "\\.azure"
  
#   # variable{
#   #   name  = "Storagekey"
#   #   value = "tempstoragekey"
#   # }
# }

# data "azurerm_subscription" "exampleSubscription" {
#   subscription_id = "tempsubscriptionid"
# }

data "azurerm_resource_group" "exampleResourcegroup" {
  #id = "tempresourcegroupid"
  name = "tempresourcenameresourcegroup"
}

data "azurerm_storage_account" "exampleStorageaccount" {
  #id                 = "tempstorageaccountid"
  name               = "tempresourcenamestorageaccount"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
}

# resource "azuredevops_variable_group" "exampleVariablegroup" {
#   project_id         = data.azuredevops_project.exampleAzuredevopsproject.project_id
#   name               = "tempresourcenamevariablegroup"
#   description        = "Managed by Terraform"
#   allow_access       = true

#   variable {
#     name  = "Organization"
#     value = "temporganizationname"
#   }

#   # variable {
#   #   name  = "Storagekey"
#   #   value = "tempstoragekey"
#   # }

#   # variable {
#   #   name  = "Project"
#   #   value = "tempprojectname"
#   # }

#   # variable {
#   #   name  = "Respository"
#   #   value = "tempprojectnameAzurerepository"
#   # }

#   # variable {
#   #   name  = "Pipeline"
#   #   value = "tempprojectnamePipeline"
#   # }

#   # variable {
#   #   name  = "Subscription"
#   #   value = "tempsubscriptionname"
#   # }

#   # variable {
#   #   name  = "Resourcegroup"
#   #   value = "tempprojectnameResourcegroup"
#   # }

#   # variable {
#   #   name  = "Storageaccount"
#   #   value = "tempprojectnameStorageaccount"
#   # }
# }