# # prepare the environment variables, from yml
# $resourceGroup = "$(resourcegroupName)"
# $serverName = "$(sqlserverName)"
# $databaseName = "$(sqldatabaseName)"

# $sqlname = "$(sqlusername)"
# $sqlpass = "$(sqlpassword)"
# $storageAccount = "$(storageaccountName)"
# $containerName = "$(backupcontainerName)"
# $storageKey = az storage account keys list --resource-group $resourceGroup --account-name $storageAccount --query "[0].value" -o tsv
# $storageUri = "https://${storageAccount}.blob.core.windows.net/${containerName}/backup-${databaseName}-$(Get-Date -Format yyyyMMddHHmmss).bacpac"

# prepare the environment variables, from script
$resourceName = ${env:resourcename} # <- required

$resourceGroup = ${env:resourcegroupname}
$serverName = $resourceName+"mssqlserver"
$databaseName = $resourceName+"mssqldatabase"
# $serverName = ${env:sqlserverName}
# $databaseName = ${env:sqldatabaseName}

$sqlname = $resourceName
$sqlpass = ${env:sqlpassword} # <- required
$storageAccount = ${env:storageaccountname} # <- required
$containerName = ${env:backupcontainer} # <- required

$storageKey = az storage account keys list --resource-group $resourceGroup --account-name $storageAccount --query "[0].value" -o tsv
$storageUri = "https://${storageAccount}.blob.core.windows.net/${containerName}/backup-${databaseName}-$(Get-Date -Format yyyyMMddHHmmss).bacpac"
#$storageKey = ${env:storagekey}
#$storageUri = ${env:storageuri}


# Check if the database exists
$dbExists = az sql db show `
--resource-group $resourceGroup `
--server $serverName `
--name $databaseName `
--query "name" -o tsv

if (-not $dbExists) {
Write-Output "Database '$databaseName' does not exist. Skipping export."
exit 0
}
Write-Output "Database '$databaseName' exists. Proceeding with export."


# disable firewall
write-host "Enabling public access to the server temporarily..."
az sql server firewall-rule create `
--resource-group "$resourceGroup" `
--server "$serverName" `
--name AllowAllWindowsAzureIps `
--start-ip-address 0.0.0.0 `
--end-ip-address 0.0.0.0

Start-Sleep -Seconds 5


# Initiate the export
write-host "Exporting db ..."
az sql db export `
--admin-user $sqlname `
--admin-password $sqlpass `
--name $databaseName `
--resource-group $resourceGroup `
--server $serverName `
--storage-key $storageKey `
--storage-key-type StorageAccessKey `
--storage-uri $storageUri


# re-enable firewall
write-host "Disabling public access to the server..."
Start-Sleep -Seconds 5

az sql server firewall-rule delete `
--resource-group "$resourceGroup" `
--server "$serverName" `
--name AllowAllWindowsAzureIps


# # verify the export
# write-host "Verifying export..."
# az storage blob list `
# --account-name "$storageAccount" `
# --container-name "$containerName" `
# --output table