resource "azurerm_service_plan" "exampleAppserviceplan" {
  name                = "tempresourcenameAppserviceplan"
  location            = azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = azurerm_resource_group.exampleResourcegroup.name
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_app_service" "exampleWebapp" {
  name                = "tempresourcenameWebapp"
  location            = azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = azurerm_resource_group.exampleResourcegroup.name
  app_service_plan_id = azurerm_service_plan.exampleAppserviceplan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "APIURL" = "tempapiurl"
  }
}

resource "azurerm_windows_web_app" "exampleApiapp" {
  name                = "tempresourcenameApiapp"
  location            = azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = azurerm_resource_group.exampleResourcegroup.name
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = false

  site_config {
    #scm_type                 = "LocalGit"
    ip_restriction_default_action = "deny"
    
    ip_restriction {
      ip_address = "tempwebappip"
      action = "Allow"
      priority = 1
    }

    ip_restriction {
      ip_address = "templocalip"
      action = "Allow"
      priority = 1
    }
  }

  connection_string {
    name  = "tempresourcenameMssql"
    type  = "SQLServer"
    value = "tempsqlconnectionstring"
  }

  connection_string {
    name  = "tempresourcenameNosql"
    type  = "DocDb"
    value = "tempnosqlconnectionstring"
  }
}