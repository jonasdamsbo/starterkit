resource "azuredevops_git_repository" "exampleAzurerepository" {
  project_id = azuredevops_project.exampleAzuredevopsproject.id
  name       = "tempAzurerepository"
  initialization {
    init_type = "Clean"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_management_lock" "exampleAzurerepositorylock" {
  name = "tempAzurerepositorylock"
  scope = azuredevops_git_repository.exampleAzurerepository.id
  lock_level = "CanNotDelete"
  notes = "Prevents repository data loss"
}

resource "azuredevops_user_entitlement" "exampleUserentitlement" {
  principal_name       = "tempPrincipalname"
  account_license_type = "basic"
}

resource "azuredevops_branch_policy_status_check" "exampleBranchpolicy" {
  project_id = azuredevops_project.exampleAzuredevopsproject.id

  enabled  = true
  blocking = true

  settings {
    name                 = "Release"
    author_id            = azuredevops_user_entitlement.exampleUserentitlement.id
    invalidate_on_update = true
    applicability        = "conditional"
    display_name         = "PreCheck"

    scope {
      repository_id  = azuredevops_git_repository.exampleAzurerepository.id
      repository_ref = azuredevops_git_repository.exampleAzurerepository.default_branch
      match_type     = "Exact"
    }

    scope {
      match_type     = "DefaultBranch"
    }
  }
}