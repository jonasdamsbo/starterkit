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

resource "azuredevops_project" "exampleAzuredevopsproject" {
  name               = "tempAzuredevopsproject"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}

resource "azuredevops_git_repository" "exampleAzurerepository" {
  project_id = azuredevops_project.exampleAzuredevopsproject.id
  name       = "tempAzurerepository"
  initialization {
    init_type = "Clean"
  }
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
  #managed_by = data.azurerm_subscription.exampleSubscription.id # optional
}

resource "azurerm_mssql_server" "exampleMssqlserver" {
  name                         = "tempMssqlserver"
  resource_group_name          = azurerm_resource_group.exampleResourcegroup.name
  location                     = azurerm_resource_group.exampleResourcegroup.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
  public_network_access_enabled = false

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = "00000000-0000-0000-0000-000000000000"
  }

  tags = {
    environment = "production"
  }
}

resource "azurerm_mssql_firewall_rule" "exampleMssqlfirewallruleApi" {
  name             = "tempMssqlfirewallruleApi"
  server_id        = azurerm_mssql_server.exampleMssqlserver.id
  start_ip_address = "tempApiip"
  end_ip_address   = "tempApiip"
}

resource "azurerm_mssql_firewall_rule" "exampleMssqlfirewallruleLocal" {
  name             = "tempMssqlfirewallruleLocal"
  server_id        = azurerm_mssql_server.exampleMssqlserver.id
  start_ip_address = "tempLocalip"
  end_ip_address   = "tempLocalip"
}

resource "azurerm_mssql_database" "exampleMssqldatabase" {
  name           = "tempMssqldatabase"
  server_id      = azurerm_mssql_server.exampleMssqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true
  enclave_type   = "VBS"

  tags = {
    foo = "bar"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_cosmosdb_account" "exampleCosmosdbaccount" {
  name                = "tempCosmosdbaccount"
  location            = azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = azurerm_resource_group.exampleResourcegroup.name
  offer_type          = "Standard"
  kind                = "MongoDB"
  public_network_access_enabled = false
  free_tier_enabled = true

  automatic_failover_enabled = true

  ip_range_filter = ["tempLocalip","tempApiip"]

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = "northeu"
    failover_priority = 1
  }

  geo_location {
    location          = "northeu"
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "exampleCosmosdbmongodb" {
  name                = "tempCosmosdbmongodb"
  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name
  account_name        = data.azurerm_cosmosdb_account.example.name
  throughput          = 400
}

resource "azurerm_service_plan" "exampleAppserviceplan" {
  name                = "tempAppserviceplan"
  location            = azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = azurerm_resource_group.exampleResourcegroup.name
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_app_service" "exampleWebapp" {
  name                = "tempWebapp"
  location            = azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = azurerm_resource_group.exampleResourcegroup.name
  app_service_plan_id = azurerm_service_plan.exampleAppserviceplan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "APIURL" = "tempApiurl"
  }
}

resource "azurerm_windows_web_app" "exampleApiapp" {
  name                = "tempApiapp"
  location            = azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = azurerm_resource_group.exampleResourcegroup.name
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = false

  site_config {
    #scm_type                 = "LocalGit"
    ip_restriction_default_action = "deny"
    
    ip_restriction {
      ip_address = "tempWebappip"
      action = "Allow"
      priority = 1
    }

    ip_restriction {
      ip_address = "tempLocalip"
      action = "Allow"
      priority = 1
    }
  }

  connection_string {
    name  = "Mssql"
    type  = "SQLServer"
    value = "tempMssqlconnectionstring"
  }

  connection_string {
    name  = "Nosql"
    type  = "DocDb"
    value = "tempNosqlconnectionstring"
  }
}