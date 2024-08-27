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