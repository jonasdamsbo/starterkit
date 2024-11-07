resource "azurerm_mssql_server" "exampleMssqlserver" {
  name                         = "tempresourcenamemssqlserver"
  resource_group_name          = data.azurerm_resource_group.exampleResourcegroup.name
  location                     = "northeurope"
  version                      = "12.0"
  administrator_login          = "tempresourcename"
  administrator_login_password = "tempsqlpassword"
  public_network_access_enabled = true

  tags = {
    environment = "production"
  }
}

resource "azurerm_mssql_database" "exampleMssqldatabase" {
  name           = "tempresourcenamemssqldatabase"
  server_id      = azurerm_mssql_server.exampleMssqlserver.id
  read_scale     = false
  sku_name       = "GP_S_Gen5_2"
  min_capacity   = 0.5
  auto_pause_delay_in_minutes = 60
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 4
  zone_redundant = true
  enclave_type   = "VBS"

  tags = {
    foo = "bar"
  }

  # prevent the possibility of accidental data loss
  # lifecycle {
  #   prevent_destroy = true
  # }
}