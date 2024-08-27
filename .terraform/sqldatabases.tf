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
resource "azurerm_management_lock" "exampleMssqlserverlock" {
  name = "tempAzureMssqlserverlock"
  scope = azurerm_mssql_server.exampleMssqlserver.id
  lock_level = "CanNotDelete"
  notes = "Prevents mssqldb data loss"
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
resource "azurerm_management_lock" "exampleMssqllock" {
  name = "tempMssqllock"
  scope = azurerm_mssql_database.exampleMssqldatabase.id
  lock_level = "CanNotDelete"
  notes = "Prevents mssqldb data loss"
}