terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  features {}
}

# giver det mening at terraform laver project? terraform ligger i repo, men 1 project kan have flere repos, men det her kan være main repo?
resource "azuredevops_project" "exampleAzuredevopsproject" {
  name               = "tempAzuredevopsproject"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_management_lock" "exampleAzuredevopsprojectlock" {
  name = "tempAzuredevopsprojectlock"
  scope = azuredevops_project.exampleAzuredevopsproject.id
  lock_level = "CanNotDelete"
  notes = "Prevents mssqldb data loss"
}

# data "azurerm_billing_mca_account_scope" "exampleBillingscope" { # problematisk, få bruger til at create en subscription inden, eller kan azure cli ?
#   billing_account_name = "tempBillingaccountname"
#   billing_profile_name = "tempBillingprofilename"
#   invoice_section_name = "tempInvoicesectionname"
# }

# output "id" {
#   value = data.azurerm_billing_mca_account_scope.exampleBillingscope.id
# }

# resource "azurerm_subscription" "exampleSubscription" {
#   subscription_name = "tempSubscription"
#   billing_scope_id  = data.azurerm_billing_mca_account_scope.exampleBillingscope.id
# }

resource "azurerm_resource_group" "exampleResourcegroup" {
  name     = "tempResourcegroup"
  location = "North Europe"
  #managed_by = data.azurerm_subscription.exampleSubscription.id # optional <-- need this?

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
resource "azurerm_management_lock" "exampleResourcegrouplock" {
  name = "tempResourcegrouplock"
  scope = azurerm_resource_group.exampleResourcegroup.id
  lock_level = "CanNotDelete"
  notes = "Prevents accidental database loss"
}

resource "azuredevops_variable_group" "exampleVariablegroup" {
  project_id   = azuredevops_project.exampleAzuredevopsproject.id
  name         = "tempVariablegroup"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "FOO"
    value = "BAR"
  }
}