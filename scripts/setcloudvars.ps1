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


### Set temp variables

    # set directly from projectcreator
        $resourcename = "tempresourcename" 
    # or get from .tf or readme
        # cd ..
        # $resourcename = (Get-Content -path README.md -Raw)
        # $findchar = $resourcename.IndexOf('Resources: ')
        # $resourcename = $resourcename.Substring($findchar+11)
        
    write-host $resourcename
    
    #cd ..

    #$nosqlpassword = "tempnosqlpassword" # sensitive
    #$sqlpassword = "tempsqlpassword" # sensitive

    $resourcegroupname = $resourcename+"resourcegroup"
    $webappname = $resourcename+"webapp"
    $apiappname = $resourcename+"apiapp"
    $sqlservername = $resourcename+"mssqlserver"
    $cosmosdbaccountname = $resourcename+"cosmosdbaccount"
    # $resourcegroupname = "tempresourcegroupname"
    # $webappname = "tempwebappname"
    # $apiappname = "tempapiappname"
    # $sqlservername = "tempmssqlservername"
    # $cosmosdbaccountname = "tempcosmosdbaccountname"

    
    #$storagekey = "tempstoragekey" # sensitive

    #$apiurl = "tempapiurl"
    #$mssqlname = "tempmssqldatabasename"
    #$containername = "tempdbbackupcontainername"
    #$nosqldbname = "tempcosmosmongodbname"

    #$nosqlconnectionstring = "mongodb+srv://sa:'"+$nosqlpassword+"'@"+$resourceName+"cosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"
    #$sqlconnectionstring = "Server=tcp:"+$resourceName+"mssqlserver.database.windows.net,1433;Initial Catalog="+$resourceName+"mssqldatabase;Persist Security Info=False;User ID="+$resourceName+";Password="+$sqlpassword+";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"


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

# get mongodb and mssqldb connectionstrings for apiapp # done in replacefiles.ps1 instead
# $nosqlconnectionstring = "
# mongodb+srv://
# "+$resourceName+":
# 'P%40ssw0rd'
# @"+$resourceName+"cosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"
#$nosqlconnectionstring = "tempnosqlconnectionstring"

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

# get webapp ip for apiapp
# $resourcegroupname = $resourceName+"resourcegroup"
# $resourcegroupname = $resourcegroup.Replace(" ","")

# $wa = $resourceName+"webapp"
# $wa = $wa.Replace(" ","")
#$wa = "tempwebappname"

### get webappip
    # $webappip = az webapp config hostname get-external-ip --resource-group $resourcegroupname --webapp-name $webappname --query "[ip]"
    # $webappip = $webappip.Trim("[","]")
    # $webappip = $webappip.Replace("[","")
    # $webappip = $webappip.Replace("]","")
    # $webappip = $webappip.Replace(" ","")
    # $webappip = $webappip+"/32"
    # $webappip = $webappip.Replace(" ","")
    # $webappipquotes = '"'+$webappip+'"'
    # $webappipquotes = $webappipquotes.Replace(" ","")
    # $webappipnobackslash = $webappip.Replace("/32","")

    $webappip = az webapp show --resource-group $resourcegroupname --name $webappname
    $webappip = $webappip | ConvertFrom-Json
    $webappip = $webappip.outboundIpAddresses
    $webappips = $webappip.Split(',')
    $webappip = $webappips[0]


# az resource show --query "[]."
# nslookup $projectName+".azurewebsites.net"

# get api ip for databases
# $wa = $resourceName+"apiapp"
# $wa = $wa.Replace(" ","")
#$wa = "tempapiappname"

### get apiapp ip
    # $apiappip = az webapp config hostname get-external-ip --resource-group $resourcegroupname --webapp-name $apiappname --query "[ip]"
    # $apiappip = $apiappip.Trim("[","]")
    # $apiappip = $apiappip.Replace("[","")
    # $apiappip = $apiappip.Replace("]","")
    # $apiappip = $apiappip.Replace(" ","")
    # $apiappip = $apiappip+"/32"
    # $apiappip = $apiappip.Replace(" ","")
    # $apiappipnobackslash = $apiappip.Replace("/32","")

    $apiappip = az webapp show --resource-group $resourcegroupname --name $apiappname
    $apiappip = $apiappip | ConvertFrom-Json
    $apiappips = $apiappip.outboundIpAddresses
    $apiappipssplit = $apiappips.Split(',')
    $apiappip = $apiappipssplit[0]


### add backupdbservice environmentvars
    # $apiappname = $resourceName+"apiapp"
    #$apiappname = "tempapiappname"
    # $mssqlname = $resourceName+"mssqldatabase"
    # $storageaccountName = $resourceName+"storageaccount"
    #$storageaccountName = "tempstorageaccountname"
    #az storage account keys list -g $resourcegroupname -n $storageaccountName --query "[0].value"
    # $containername = "dbbackup"

    # -> DO IN REPLACETOKENS
    # az webapp config appsettings set -g $resourcegroupname -n $apiappname --settings "MyApiSettings:DatabaseName"=$mssqlname
    # az webapp config appsettings set -g $resourcegroupname -n $apiappname --settings "MyApiSettings:AzureStorageConnectionString"=$storagekey
    # az webapp config appsettings set -g $resourcegroupname -n $apiappname --settings "MyApiSettings:StorageContainerName"=$containername


### add apiurl to webapp
    # $webappname = $resourceName+"Webapp" # done in replacefiles instead
    #$webappname = "tempwebappname"

    # -> DO IN .TF+REPLACETOKENS
    # az webapp config appsettings set -g $resourcegroupname -n $webappname --settings "APIURL"=$apiurl # set in cloud


### add connectionstrings to api
    #$apiappname = $resourceName+"apiapp" # done in replacefiles instead
    #az webapp config connection-string set -g $resourcegroupname -n $apiappname -t "SQLServer" --settings Mssql=$sqlconnectionstring # set in cloud
    #az webapp config connection-string set -g $resourcegroupname -n $apiappname -t "DocDb" --settings Nosql=$nosqlconnectionstring # set in cloud
    # $nosqldbname = $resourceName+"cosmosmongodb"

    # -> DO IN .TF+REPLACETOKENS
    # az webapp config connection-string set -g $resourcegroupname -n $apiappname -t "SQLServer" --settings Mssql=$sqlconnectionstring
    # az webapp config appsettings set -g $resourcegroupname -n $apiappname --settings "NosqlDatabase:ConnectionString"=$nosqlconnectionstring
    # az webapp config appsettings set -g $resourcegroupname -n $apiappname --settings "NosqlDatabase:DatabaseName"=$nosqldbname


### add webapp ip to api
    #write-host "################################ Adding webappip to api ################################"
    #$apiappname = $resourceName+"apiapp"
    write-host "### Update apiapp"
    $xindex = 1
    foreach ($item in $webappips)
    {
        $rulename = "webappip"+$xindex
        az webapp config access-restriction add --resource-group $resourcegroupname --name $apiappname --rule-name $rulename --action Allow --ip-address $item --priority 1
        $xindex = $xindex + 1
    }

### TEMP overwrite nosqlpassword
    write-host "### get nosqlkey"
    #$nosqlkey = az cosmosdb keys list --resource-group $resourcegroupname --name $cosmosdbaccountname --query "[primaryMasterKey]" --output tsv



    # $nosqlkey = az cosmosdb keys list --resource-group jgde2exresourcegroup --name jgde2excosmosdbaccount --type connection-strings --query "[connectionStrings[0].connectionString]"
    # $nosqlkey = $nosqlkey.Replace("[","")
    # $nosqlkey = $nosqlkey.Replace("]","")
    # $nosqlkey = $nosqlkey.Replace(" ","")

    $nosqlkey = az cosmosdb keys list --resource-group $resourcegroupname --name $cosmosdbaccountname --type connection-strings --query "[connectionStrings[0].connectionString]" --output tsv

    $nosqlkey = $nosqlkey.Split('&')

    write-host $nosqlkey[0]
    $nosqlkey = $nosqlkey[0]
    $set123 = "NosqlDatabase:ConnectionString=$nosqlkey"
    write-host $set123

    write-host "### overwrite nosqlkey"
    az webapp config appsettings set -g $resourcegroupname -n $apiappname --settings $set123
    write-host "### nosqlkey overwritten"

### add apiapp ip to sqldb
    #write-host "################################ Adding apiappip to mssqldb ################################"
    # $sqlservername = $resourceName+"mssqlserver"
    write-host "### Update sqldb"
    $xindex = 1
    foreach ($item in $apiappipssplit)
    {
        $rulename = "apiappip"+$xindex
        az sql server firewall-rule create --resource-group $resourcegroupname -s $sqlservername --name $rulename --start-ip-address $item --end-ip-address $item
        $xindex = $xindex + 1
    }

### add apiapp ip to nosql
    #write-host "################################ Adding apiappip to nosqldb ################################"
    # $cosmosdbaccountname = $resourceName+"cosmosdbaccount"
    # write-host "### Show cosmosdb" # questionable ip update
    # $iprange = az cosmosdb show --name $cosmosdbaccountname --resource-group $resourcegroupname --query "ipRules" --output tsv
    # # # $iprange = $iprange.Replace("]", "")
    # # # $iprange = $iprange.Replace("}","")
    # # # $iprange = $iprange.Replace("{","")
    # if($iprange.Length -lt 1)
    # {
    #     $iprange = '["'+$apiappip+'"]'
    #     $iprange = $iprange.Replace(" ","")
    # }
    # else
    # {
    #     $iprange = $iprange.Trim("[","]")
    #     $iprange = $iprange.Replace("[","")
    #     $iprange = $iprange.Replace("]","")
    #     $iprange = $iprange.Replace(" ","")
    #     $iprange = '['+$iprange+','+$apiappip+']'
    #     $iprange = $iprange.Replace(" ","")
    # }
    # $iprangenobraces = $iprange.Trim('[',']')
    # #$iprangenoquotes = $iprange.Replace('"','')
    # $iprangenoquotesandbraces = $iprangenobraces.Replace('"','')
    # #$iprangenoquotesbracesbackslash = $iprangenoquotesandbraces.Replace('/32','')
    # #$iprangequotes = '"'+$iprangenoquotesandbraces+'"'
    # #$iprangequotes = $iprangequotes.Replace(" ","")
    # write-host "Iprange: "$iprangequotes
    write-host "### Updating cosmosdb"
    #az cosmosdb update --name $cosmosdbaccountname --resource-group $resourcegroupname --ip-range-filter $iprangenoquotesandbraces #$apiappip

    # $myips = ""
    # $myindex = 0
    # foreach ($item in $apiappips)
    # {
    #     if($myindex -ne 0)
    #     {
    #         $myips = $myips+","+$item
    #     }
    #     if($myindex -eq 0)
    #     {
    #         $myips = $item
    #     }
    #     $myindex = $myindex + 1;
    # }

    write-host $apiappips

    az cosmosdb update --name $cosmosdbaccountname --resource-group $resourcegroupname --ip-range-filter $apiappips #$apiappip

    write-host "### Done updating cosmosdb"


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