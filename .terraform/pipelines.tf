resource "azuredevops_build_definition" "examplePipeline" {
  project_id = azuredevops_project.exampleAzuredevopsproject.id
  name       = "tempPipeline"
  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = false
  }

  schedules {
    branch_filter {
      include = ["master"]
      exclude = ["test", "regression"]
    }
    days_to_build              = ["Wed", "Sun"]
    schedule_only_with_changes = true
    start_hours                = 10
    start_minutes              = 59
    time_zone                  = "(UTC) Coordinated Universal Time"
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.exampleAzurerepository.id
    branch_name = azuredevops_git_repository.exampleAzurerepository.default_branch
    yml_path    = ".azure/azurepipeline.yml"
  }

  variable_groups = [
    azuredevops_variable_group.exampleVariablegroup.id
  ]

  variable {
    name  = "PipelineVariable"
    value = "Go Microsoft!"
  }

  variable {
    name         = "PipelineSecret"
    secret_value = "ZGV2cw"
    is_secret    = true
  }
}