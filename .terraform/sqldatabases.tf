resource "azurerm_mssql_server" "exampleMssqlserver" {
  name                         = "tempresourceMssqlserver"
  resource_group_name          = data.azurerm_resource_group.exampleResourcegroup.name
  location                     = data.azurerm_resource_group.exampleResourcegroup.location
  version                      = "12.0"
  administrator_login          = "tempresourcename"
  administrator_login_password = "P@ssw0rd"
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
  name = "tempresourceMssqlserverlock"
  scope = azurerm_mssql_server.exampleMssqlserver.id
  lock_level = "CanNotDelete"
  notes = "Prevents mssqldb data loss"
}

resource "azurerm_mssql_firewall_rule" "exampleMssqlfirewallruleApi" {
  name             = "tempresourceMssqlfirewallruleApi"
  server_id        = azurerm_mssql_server.exampleMssqlserver.id
  start_ip_address = "tempapiappip"
  end_ip_address   = "tempapiappip"
}

resource "azurerm_mssql_firewall_rule" "exampleMssqlfirewallruleLocal" {
  name             = "tempresourceMssqlfirewallruleLocal"
  server_id        = azurerm_mssql_server.exampleMssqlserver.id
  start_ip_address = "templocalip"
  end_ip_address   = "templocalip"
}

resource "azurerm_mssql_database" "exampleMssqldatabase" {
  name           = "tempresourceMssqldatabase"
  server_id      = azurerm_mssql_server.exampleMssqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "GP_S_Gen5"
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
  name = "tempresourcenameMssqllock"
  scope = azurerm_mssql_database.exampleMssqldatabase.id
  lock_level = "CanNotDelete"
  notes = "Prevents mssqldb data loss"
}