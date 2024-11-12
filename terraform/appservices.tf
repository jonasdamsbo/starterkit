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
    ip_restriction_default_action = "Allow"
    always_on = "false"
  }

  app_settings = {
    "MyAppSettings:APIURL" = "https://tempresourcenameapiapp.azurewebsites.net/"
    "ASPNETCORE_ENVIRONMENT" = "Production"
  }
}

resource "azurerm_windows_web_app" "exampleApiapp" {
  name                = "tempresourcenameapiapp"
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = true

  site_config {
    ip_restriction_default_action = "Deny"
    always_on = "false"
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = "Production"
  }

  connection_string {
    name  = "Mssql"
    type  = "SQLServer"
    value = "Server=tcp:tempresourcenamemssqlserver.database.windows.net,1433;Initial Catalog=tempresourcenamemssqldatabase;Persist Security Info=False;User ID=tempresourcename;Password=tempsqlpassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}