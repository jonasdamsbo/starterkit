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
    #"MyAppSettings:APIURL" = "tempapiurl"
    "MyAppSettings:APIURL" = "https://tempresourcenameapiapp.azurewebsites.net/" #azurerm_windows_web_app.exampleApiapp.default_hostname
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
    #scm_type                 = "LocalGit"
    ip_restriction_default_action = "Deny"
    always_on = "false"
    
    # ip_restriction {
    #   ip_address = azurerm_windows_web_app.exampleWebapp.outbound_ip_addresses #"tempwebappip"
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
    #"NosqlDatabase:ConnectionString" = "tempnosqlconnectionstring"
    "NosqlDatabase:ConnectionString" = "mongodb+srv://sa:'tempnosqlpassword'@tempresourcenamecosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"
    "NosqlDatabase:DatabaseName" = "tempresourcenamecosmosmongodb"

    "MyApiSettings:DatabaseName" = "tempresourcenamemssqldatabase"
    "MyApiSettings:AzureStorageConnectionString" = "tempstoragekey"
    "MyApiSettings:StorageContainerName" = "tempdbbackupcontainername" #"dbbackup"

    "ASPNETCORE_ENVIRONMENT" = "Production"
  }

  connection_string {
    name  = "Mssql"
    type  = "SQLServer"
    value = "Server=tcp:tempresourcenamemssqlserver.database.windows.net,1433;Initial Catalog=tempresourcenamemssqldatabase;Persist Security Info=False;User ID=tempresourcename;Password=tempsqlpassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    #value = "tempsqlconnectionstring"
  }

  # connection_string {
  #   name  = "Nosql"
  #   type  = "DocDb"
  #   value = "tempnosqlconnectionstring"
  # }
}