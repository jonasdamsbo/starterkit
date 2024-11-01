### replace tokens in scripts after terraform before deploy

# replace terraform .tf tokens


# replace setcloudvars.ps1 tokens
$resourcename = "$env:RESOURCENAME"
$apiurl = "$env:APIURL"
$nosqlconnectionstring = "$env:NOSQLCONNECTIONSTRING"
$mssqlconnectionstring = "$env:MSSQLCONNECTIONSTRING"
$resourcegroupname = "$env:RESOURCEGROUPNAME"
$webappname = "$env:WEBAPPNAME"
$apiappname = "$env:APIAPPNAME"
$mssqlservername = "$env:MSSQLSERVERNAME"
$mssqldatabasename = "$env:MSSQLDATABASENAME"
$storageaccountname = "$env:STORAGEACCOUNTNAME"
$storagekey = "$env:STORAGEKEY"
$dbbackupcontainername = "$env:DBBACKUPCONTAINERNAME"
$nosqlaccountname = "$env:NOSQLACCOUNTNAME"
$nosqldatabasename = "$env:NOSQLDATABASENAME"