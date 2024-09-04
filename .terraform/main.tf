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
      resource_group_name  = azurerm_resource_group.exampleResourcegroup.name
      storage_account_name = azurerm_storage_account.exampleStorageaccount.name
      container_name       = "terraform"
      key                  = "terraform.tfstate"
      access_key = "tempstoragekey"

      features{}
  }
}

provider "azurerm" {
  subscription_id = "tempsubscriptionid"
  features {}
}

provider "azuredevops" {
  
}

# giver det mening at terraform laver project? terraform ligger i repo, men 1 project kan have flere repos, men det her kan være main repo?
data "azuredevops_project" "exampleAzuredevopsproject" {
  id                 = "tempazuredevopsprojectid"
  name               = "tempprojectname"
}

data "azuredevops_git_repository" "exampleAzurerepository" {
  id                 = "tempazurerepositoryid"
  name               = "tempresourcenameAzurerepository"
  project_id         = azuredevops_project.exampleAzuredevopsproject.id
  default_branch     = "main"
}

data "azuredevops_branch_policy_status_check" "exampleBranchpolicy" {
  scope {
    match_type       = azuredevops_git_repository.exampleAzurerepository.default_branch
  }
}

data "azuredevops_build_definition" "examplePipeline" {
  id                 = "temppipelineid"
  name               = "tempresourcenamePipeline"
  project_id         = azuredevops_project.exampleAzuredevopsproject.id

  repository {
    repo_id     = azuredevops_git_repository.exampleAzurerepository.id
    yml_path    = ".azure/azure-pipelines.yml"
    #repo_type   = "TfsGit"
    #branch_name = azuredevops_git_repository.exampleAzurerepository.default_branch
  }
  #path               = "\\.azure"
  
  variable{
    name  = "Storagekey"
    value = "tempstoragekey"
  }
}

data "azurerm_subscription" "exampleSubscription" {
  id                 = "tempsubscriptionid"
}

data "azurerm_resource_group" "exampleResourcegroup" {
  id                 = "tempresourcegroupid"
  name               = "tempresourcenameResourcegroup"
}

data "azurerm_storage_account" "exampleStorageaccount" {
  id                 = "tempstorageaccountid"
  name               = "tempresourcenameStorageaccount"
  resource_group_name =  azurerm_resource_group.exampleResourcegroup.name
}

resource "azuredevops_variable_group" "exampleVariablegroup" {
  project_id         = azuredevops_project.exampleAzuredevopsproject.id
  name               = "tempresourcenameVariablegroup"
  description        = "Managed by Terraform"
  allow_access       = true

  variable {
    name  = "Organization"
    value = "temporganizationname"
  }

  # variable {
  #   name  = "Storagekey"
  #   value = "tempstoragekey"
  # }

  # variable {
  #   name  = "Project"
  #   value = "tempprojectname"
  # }

  # variable {
  #   name  = "Respository"
  #   value = "tempprojectnameAzurerepository"
  # }

  # variable {
  #   name  = "Pipeline"
  #   value = "tempprojectnamePipeline"
  # }

  # variable {
  #   name  = "Subscription"
  #   value = "tempsubscriptionname"
  # }

  # variable {
  #   name  = "Resourcegroup"
  #   value = "tempprojectnameResourcegroup"
  # }

  # variable {
  #   name  = "Storageaccount"
  #   value = "tempprojectnameStorageaccount"
  # }
}