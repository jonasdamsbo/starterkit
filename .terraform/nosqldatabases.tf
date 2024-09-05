resource "azurerm_cosmosdb_account" "exampleCosmosdbaccount" {
  name                = "tempresourcenameCosmosdbaccount"
  location            = data.azurerm_resource_group.exampleResourcegroup.location
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  offer_type          = "Standard"
  kind                = "MongoDB"
  public_network_access_enabled = false
  free_tier_enabled = true

  automatic_failover_enabled = true

  ip_range_filter = ["templocalip","tempapiappip"]

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = "southindia"
    failover_priority = 1
  }

  geo_location {
    location          = "southindia"
    failover_priority = 0
  }

# prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
resource "azurerm_management_lock" "exampleCosmosdbaccountlock" {
  name = "tempresourcenameCosmosdbaccountlock"
  scope = azurerm_cosmosdb_account.exampleCosmosdbaccount.id
  lock_level = "CanNotDelete"
  notes = "Prevents nosqldb data loss"
}

resource "azurerm_cosmosdb_mongo_database" "exampleCosmosdbmongodb" {
  name                = "tempresourcenameCosmosdbmongodb"
  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name
  account_name        = data.azurerm_cosmosdb_account.example.name
  throughput          = 400

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
resource "azurerm_management_lock" "exampleCosmosdbmongodblock" {
  name = "tempresourcenameCosmosdbmongodblock"
  scope = azurerm_cosmosdb_mongo_database.exampleCosmosdbmongodb.id
  lock_level = "CanNotDelete"
  notes = "Prevents nosqldb data loss"
}

resource "azurerm_cosmosdb_mongo_user_definition" "exampleCosmosdbmongodbuserdefinition" {
  cosmos_mongo_database_id = azurerm_cosmosdb_mongo_database.exampleCosmosdbmongodb.id
  username                 = "tempresourcename"
  password                 = "P4ssw0rd"
}