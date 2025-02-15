resource "azurerm_service_plan" "exampleAppserviceplan" {
  name                = "tempresourcenameappserviceplan"
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name # "tempresourcenameresourcegroup"
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_windows_web_app" "exampleWebapp" {
  name                = "tempresourcenamewebapp"
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name # "tempresourcenameresourcegroup"
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = true

  https_only = true

  site_config {
    ip_restriction_default_action = "Allow"
    always_on = "false"
  }

  logs{
    application_logs {
      file_system_level = "Verbose"
    }
    detailed_error_messages = "true"
    failed_request_tracing = "true"
  }

  app_settings = {
    "MyAppSettings:APIURL" = "https://tempresourcenameapiapp.azurewebsites.net/"
    "ASPNETCORE_ENVIRONMENT" = "Production"
  }
}

resource "azurerm_windows_web_app" "exampleApiapp" {
  name                = "tempresourcenameapiapp"
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name # "tempresourcenameresourcegroup"
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = true

  https_only = true

  site_config {
    ip_restriction_default_action = "Deny"
    always_on = "false"
  }

  logs{
    application_logs {
      file_system_level = "Verbose"
    }
    detailed_error_messages = "true"
    failed_request_tracing = "true"
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = "Production"
    # "MyApiSettings:DatabaseName" = azurerm_mssql_database.exampleMssqldatabase.name
    # "MyApiSettings:AzureStorageConnectionString" = "tempstorageconnectionstring"
    # "MyApiSettings:StorageContainerName" = "tempdbbackupcontainer" # "dbbackup"
    # "AzureServiceSettings:PAT" = "temppat"
    # "AzureServiceSettings:ORGANIZATIONNAME" = "temporganizationname"
    # "AzureServiceSettings:FULLORGANIZATIONNAME" = "tempfullorganizationname"
    # "AzureServiceSettings:SUBSCRIPTIONNAME" = "tempsubscriptionname"
    # "AzureServiceSettings:SUBSCRIPTIONID" = "tempsubscriptionid"
    # "AzureServiceSettings:CLIENTID" = "tempclientid"
    # "AzureServiceSettings:CLIENTSECRET" = "tempclientsecret"
    # "AzureServiceSettings:TENANTID" = "temptenantid"
    # "AzureServiceSettings:PROJECTNAME" = "tempprojectname"
    # "AzureServiceSettings:RESOURCENAME" = "tempresourcename"
  }

  connection_string {
    name  = "Mssql"
    type  = "SQLServer"
    value = "Server=tcp:tempresourcenamemssqlserver.database.windows.net,1433;Initial Catalog=tempresourcenamemssqldatabase;Persist Security Info=False;User ID=tempresourcename;Password=tempsqlpassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    #value = "tempsqlconnectionstring"
  }
}