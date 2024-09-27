resource "azurerm_service_plan" "exampleAppserviceplan" {
  name                = "tempresourcenameappserviceplan"
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_windows_web_app" "exampleWebapp" {
  name                = "tempresourcenamewebapp"
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = true

  site_config {
    #dotnet_framework_version = "v4.0"
    #scm_type                 = "LocalGit"
    ip_restriction_default_action = "Allow"
    always_on = "false"
  }

  app_settings = {
    "MyAppSettings:APIURL" = "tempapiurl"
  }
}

resource "azurerm_windows_web_app" "exampleApiapp" {
  name                = "tempresourcenameapiapp"
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = true

  site_config {
    #scm_type                 = "LocalGit"
    ip_restriction_default_action = "Deny"
    always_on = "false"
    
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

  app_settings = {
    "NosqlDatabase:ConnectionString" = "tempnosqlconnectionstring"
    "NosqlDatabase:DatabaseName" = "tempresourcenamecosmosmongodb"
  }

  connection_string {
    name  = "Mssql"
    type  = "SQLServer"
    value = "tempsqlconnectionstring"
  }

  # connection_string {
  #   name  = "Nosql"
  #   type  = "DocDb"
  #   value = "tempnosqlconnectionstring"
  # }
}