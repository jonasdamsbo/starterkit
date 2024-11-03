### run terraform with chosen projectname prepended on services names
# devops project
# devops repository
# devops variable group
# devops pipeline/build definition
# azure billing scope
# azure subscription
# azure resourcegroup
# azure app service plan
# azure web app
# azure api app
# azure sql server
# azure sql database
# azure cosmos account
# azure cosmos mongodb

### setting app env vars and db ips
write-host "SETTING CLOUD VARS"

# cd terraform folder
#cd ".terraform"

# terraform initial init/plan/apply
# terraform init
# terraform plan
# terraform apply -auto-approve


###  replace cloud vars in cloud files (needs the above apply to create apps, and in turn generate ips)

# get local ip for apiapp and databases
#$localip = ""

#$resourceName = "tempresourcename"

# get apiurl for webapp # done in replacefiles.ps1 instead
#$apiurl = $resourceName+"Apiapp.azurewebsites.net"
$apiurl = "tempapiurl"

# get mongodb and mssqldb connectionstrings for apiapp # done in replacefiles.ps1 instead
# $nosqlconnectionstring = "
# mongodb+srv://
# "+$resourceName+":
# 'P%40ssw0rd'
# @"+$resourceName+"cosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"
#$nosqlconnectionstring = "tempnosqlconnectionstring"
$nosqlpassword = "tempnosqlpassword"
$nosqlconnectionstring = "mongodb+srv://sa:'"+$nosqlpassword+"'@"+$resourceName+"cosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"

# $sqlconnectionstring = "
# Server=tcp:"+$resourceName+"sqldbserver.database.windows.net,1433;
# Initial Catalog="+$resourceName+"sqldb;
# Persist Security Info=False;
# User ID="+$resourceName+";Password=P@ssw0rd;
# MultipleActiveResultSets=False;
# Encrypt=True;
# TrustServerCertificate=False;
# Connection Timeout=30;
# "
#$sqlconnectionstring = "tempsqlconnectionstring"
$sqlpassword = "tempsqlpassword"
$sqlconnectionstring = "Server=tcp:"+$resourceName+"mssqlserver.database.windows.net,1433;Initial Catalog="+$resourceName+"mssqldatabase;Persist Security Info=False;User ID="+$resourceName+";Password="+$sqlpassword+";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

# get webapp ip for apiapp
# $rg = $resourceName+"resourcegroup"
# $rg = $rg.Replace(" ","")
$rg = "tempresourcegroupname"

# $wa = $resourceName+"webapp"
# $wa = $wa.Replace(" ","")
#$wa = "tempwebappname"
$webappname = "tempwebappname"

$webappip = az webapp config hostname get-external-ip --resource-group $rg --webapp-name $webappname --query "[ip]"
$webappip = $webappip.Trim("[","]")
$webappip = $webappip.Replace("[","")
$webappip = $webappip.Replace("]","")
$webappip = $webappip.Replace(" ","")
$webappip = $webappip+"/32"
$webappip = $webappip.Replace(" ","")
$webappipquotes = '"'+$webappip+'"'
$webappipquotes = $webappipquotes.Replace(" ","")
$webappipnobackslash = $webappip.Replace("/32","")
# az resource show --query "[]."
# nslookup $projectName+".azurewebsites.net"

# get api ip for databases
# $wa = $resourceName+"apiapp"
# $wa = $wa.Replace(" ","")
#$wa = "tempapiappname"
$apiappname = "tempapiappname"

$apiappip = az webapp config hostname get-external-ip --resource-group $rg --webapp-name $apiappname --query "[ip]"
$apiappip = $apiappip.Trim("[","]")
$apiappip = $apiappip.Replace("[","")
$apiappip = $apiappip.Replace("]","")
$apiappip = $apiappip.Replace(" ","")
$apiappip = $apiappip+"/32"
$apiappip = $apiappip.Replace(" ","")
$apiappipnobackslash = $apiappip.Replace("/32","")


# add backupdbservice environmentvars
# $apiappname = $resourceName+"apiapp"
#$apiappname = "tempapiappname"
# $mssqlname = $resourceName+"mssqldatabase"
$mssqlname = "tempmssqldatabasename"
# $storageaccountName = $resourceName+"storageaccount"
#$storageaccountName = "tempstorageaccountname"
$storagekey = "tempstoragekey" #az storage account keys list -g $rg -n $storageaccountName --query "[0].value"
# $containername = "dbbackup"
$containername = "tempdbbackupcontainername"
az webapp config appsettings set -g $rg -n $apiappname --settings "MyApiSettings:DatabaseName"=$mssqlname
az webapp config appsettings set -g $rg -n $apiappname --settings "MyApiSettings:AzureStorageConnectionString"=$storagekey
az webapp config appsettings set -g $rg -n $apiappname --settings "MyApiSettings:StorageContainerName"=$containername

# add apiurl to webapp
# $webappname = $resourceName+"Webapp" # done in replacefiles instead
#$webappname = "tempwebappname"
az webapp config appsettings set -g $rg -n $webappname --settings "APIURL"=$apiurl # set in cloud

# add connectionstrings to api
#$apiappname = $resourceName+"apiapp" # done in replacefiles instead
#az webapp config connection-string set -g $rg -n $apiappname -t "SQLServer" --settings Mssql=$sqlconnectionstring # set in cloud
#az webapp config connection-string set -g $rg -n $apiappname -t "DocDb" --settings Nosql=$nosqlconnectionstring # set in cloud
az webapp config connection-string set -g $rg -n $apiappname -t "SQLServer" --settings Mssql=$sqlconnectionstring
az webapp config appsettings set -g $rg -n $apiappname --settings "NosqlDatabase:ConnectionString"=$nosqlconnectionstring
# $nosqldbname = $resourceName+"cosmosmongodb"
$nosqldbname = "tempcosmosmongodbname"
az webapp config appsettings set -g $rg -n $apiappname --settings "NosqlDatabase:DatabaseName"=$nosqldbname

# add webbapp ip to api
write-host "################################ Adding webappip to api ################################"
    #$apiappname = $resourceName+"apiapp"
    az webapp config access-restriction add --resource-group $rg --name $apiappname --rule-name "webappip" --action Allow --ip-address $webappipnobackslash --priority 1

# add api ip to dbs
write-host "################################ Adding apiappip to mssqldb ################################"
    # $sqlservername = $resourceName+"mssqlserver"
    $sqlservername = "tempmssqlservername"
    az sql server firewall-rule create --resource-group $rg -s $sqlservername --name "apiappip" --start-ip-address $apiappipnobackslash --end-ip-address $apiappipnobackslash

write-host "################################ Adding apiappip to nosqldb ################################"
    # $cosmosdbaccount = $resourceName+"cosmosdbaccount"
    $cosmosdbaccount = "tempcosmosdbaccountname"
    write-host "### Show cosmosdb" # questionable ip update
    $iprange = az cosmosdb show --name $cosmosdbaccount --resource-group $rg --query "ipRules" --output tsv
    # # $iprange = $iprange.Replace("]", "")
    # # $iprange = $iprange.Replace("}","")
    # # $iprange = $iprange.Replace("{","")
    if($iprange.Length -lt 1)
    {
        $iprange = '["'+$apiappip+'"]'
        $iprange = $iprange.Replace(" ","")
    }
    else
    {
        $iprange = $iprange.Trim("[","]")
        $iprange = $iprange.Replace("[","")
        $iprange = $iprange.Replace("]","")
        $iprange = $iprange.Replace(" ","")
        $iprange = '['+$iprange+','+$apiappip+']'
        $iprange = $iprange.Replace(" ","")
    }
    $iprangenobraces = $iprange.Trim('[',']')
    #$iprangenoquotes = $iprange.Replace('"','')
    $iprangenoquotesandbraces = $iprangenobraces.Replace('"','')
    #$iprangenoquotesbracesbackslash = $iprangenoquotesandbraces.Replace('/32','')
    #$iprangequotes = '"'+$iprangenoquotesandbraces+'"'
    #$iprangequotes = $iprangequotes.Replace(" ","")
    write-host "Iprange: "$iprangequotes
    write-host "### Update cosmosdb"
    az cosmosdb update --name $cosmosdbaccount --resource-group $rg --ip-range-filter $iprangenoquotesandbraces #$apiappip



# # add apiurl to webapp
# ((Get-Content -path appservices.tf -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path appservices.tf

# # add local ip and webapp ip to api -> maybe not local ip?
# ((Get-Content -path appservices.tf -Raw) -replace 'tempwebappip',$webappip) | Set-Content -Path appservices.tf
# #((Get-Content -path appservices.tf -Raw) -replace 'templocalip',$localip) | Set-Content -Path appservices.tf

# # add mongodb and mssqldb connectionstrings to api
# ((Get-Content -path appservices.tf -Raw) -replace 'tempnosqlconnectionstring',$nosqlconnectionstring) | Set-Content -Path appservices.tf
# ((Get-Content -path appservices.tf -Raw) -replace 'tempsqlconnectionstring',$sqlconnectionstring) | Set-Content -Path appservices.tf

# # add local ip and api ip to mongodb and mssqldb (templocalip, tempapiappip)
# ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempapiappip',$apiappip) | Set-Content -Path sqldatabases.tf
# ((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempapiappip',$apiappip) | Set-Content -Path nosqldatabases.tf
# #((Get-Content -path sqldatabases.tf -Raw) -replace 'templocalip',$localip) | Set-Content -Path sqldatabases.tf
# #((Get-Content -path nosqldatabases.tf -Raw) -replace 'templocalip',$localip) | Set-Content -Path nosqldatabases.tf

# terraform second init/plan/apply
# terraform init
# terraform plan
# terraform apply -auto-approve

# flip branch policy to enabled aka "no direct push to master"-rule # kan gøres ved at den er outcommentet ved apply, efter apply outcommenter jeg ved at replace "#" med ""
#((Get-Content -path repositories.tf -Raw) -replace 'enabled  = false','enabled  = true') | Set-Content -Path repositories.tf

# cd projectfolder
#cd ..


#read-host "Enter to proceed..."
# # # get webappurl -> put webappurl in readme?

# # # Replace cloud vars in new-project.ps1 + pipeline.yml and push, own file? # uses data after cloud is created

# # # replace temp vars in readme, -> org/subscription?, (project?+add connectionstrings, webappurl and apiurl to readme?)?

write-host "DONE SETTING CLOUD VARS"