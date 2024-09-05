resource "azurerm_service_plan" "exampleAppserviceplan" {
  name                = "tempresourcenameappserviceplan"
  location            = data.azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_windows_web_app" "exampleWebapp" {
  name                = "tempresourcenamewebapp"
  location            = data.azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = true

  site_config {
    #dotnet_framework_version = "v4.0"
    #scm_type                 = "LocalGit"
    ip_restriction_default_action = "Allow"
  }

  app_settings = {
    "APIURL" = "tempapiurl"
  }
}

resource "azurerm_windows_web_app" "exampleApiapp" {
  name                = "tempresourcenameapiapp"
  location            = data.azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = false

  site_config {
    #scm_type                 = "LocalGit"
    ip_restriction_default_action = "Deny"
    
    # ip_restriction {
    #   ip_address = "tempwebappip"
    #   action = "Allow"
    #   priority = 1
    # }

    # ip_restriction {
    #   ip_address = "templocalip"
    #   action = "Allow"
    #   priority = 1
    # }
  }

  connection_string {
    name  = "Mssql"
    type  = "SQLServer"
    value = "tempsqlconnectionstring"
  }

  connection_string {
    name  = "Nosql"
    type  = "DocDb"
    value = "tempnosqlconnectionstring"
  }
}