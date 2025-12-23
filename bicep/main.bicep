param location string = resourceGroup().location
param environment string
param appNamePrefix string = 'myapp'

var environmentConfig = {
    dev: {
        appServicePlanSku: 'F1'
        sqlServerAdminPassword: 'Dev@${uniqueString(resourceGroup().id)}123'
        tags: {
            environment: 'dev'
            costCenter: 'development'
        }
    }
    test: {
        appServicePlanSku: 'F1'
        sqlServerAdminPassword: 'Test@${uniqueString(resourceGroup().id)}123'
        tags: {
            environment: 'test'
            costCenter: 'testing'
        }
    }
    prod: {
        appServicePlanSku: 'F1'
        sqlServerAdminPassword: 'Prod@${uniqueString(resourceGroup().id)}123'
        tags: {
            environment: 'prod'
            costCenter: 'production'
        }
    }
}

var config = environmentConfig[environment]
var resourceNamePrefix = '${appNamePrefix}-${environment}'

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
    name: '${resourceNamePrefix}-plan'
    location: location
    sku: {
        name: config.appServicePlanSku
    }
    tags: config.tags
}

// Frontend Web App
resource frontendWebApp 'Microsoft.Web/sites@2023-01-01' = {
    name: '${resourceNamePrefix}-frontend'
    location: location
    properties: {
        serverFarmId: appServicePlan.id
    }
    tags: config.tags
}

// Backend API Web App
resource backendWebApp 'Microsoft.Web/sites@2023-01-01' = {
    name: '${resourceNamePrefix}-backend'
    location: location
    properties: {
        serverFarmId: appServicePlan.id
    }
    tags: config.tags
}

// SQL Server
resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
    name: '${resourceNamePrefix}-sqlserver'
    location: location
    properties: {
        administratorLogin: 'sqladmin'
        administratorLoginPassword: config.sqlServerAdminPassword
    }
    tags: config.tags
}

output frontendUrl string = 'https://${frontendWebApp.properties.defaultHostName}'
output backendUrl string = 'https://${backendWebApp.properties.defaultHostName}'
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
