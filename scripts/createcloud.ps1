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

# cd terraform folder
#cd ".terraform"

# terraform initial init/plan/apply
# terraform init
# terraform plan
# terraform apply -auto-approve


###  replace cloud vars in cloud files (needs the above apply to create apps, and in turn generate ips)

# get local ip for apiapp and databases
#$localip = ""

write-host "setting app env vars and db ips"

# get apiurl for webapp
$apiurl = $resourceName+"Apiapp.azurewebsites.net"

# get mongodb and mssqldb connectionstrings for apiapp
$nosqlconnectionstring = "
mongodb+srv://
"+$resourceName+":
'P4ssw0rd'
@"+$resourceName+"cosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"

$sqlconnectionstring = "
Server=tcp:"+$resourceName+"sqldbserver.database.windows.net,1433;
Initial Catalog="+$resourceName+"sqldb;
Persist Security Info=False;
User ID="+$resourceName+";Password=P@ssw0rd;
MultipleActiveResultSets=False;
Encrypt=True;
TrustServerCertificate=False;
Connection Timeout=30;
"

# get webapp ip for apiapp
$rg = $resourceName+"resourcegroup"
$wa = $resourceName+"webapp"
$webappip = az webapp config hostname get-external-ip --resource-group $rg --webapp-name $wa --query "[ip]"
$webappip = $webappip+"/32"
# az resource show --query "[]."
# nslookup $projectName+".azurewebsites.net"

# get api ip for databases
$wa = $resourceName+"apiapp"
$apiappip = az webapp config hostname get-external-ip --resource-group $rg --webapp-name $wa --query "[ip]"
$apiappip = $apiappip+"/32"


# add apiurl to webapp
$webappname = $resourcename+"Webapp"
az webapp config appsettings set -g $resourcegroupName -n $webappname --settings APIURL=$apiurl

# add connectionstrings to api
$apiappname = $resourcename+"Apiapp"
az webapp config connection-string set -g $resourcegroupName -n $apiappname -t SQLServer --settings Mssql=$sqlconnectionstring
az webapp config connection-string set -g $resourcegroupName -n $apiappname -t DocDb --settings Nosql=$nosqlconnectionstring

# add webbapp ip to api
az webapp config access-restriction add -g $resourcegroupName -n $apiappname --rule-name webapp --action Allow --ip-address $webappip --priority 1

# add api ip to dbs
$sqlservername = $resourceName+"sqldbserver"
az sql server firewall-rule create -g $resourcegroupName -s $sqlservername -n "Apiappip" --start-ip-address $apiappip --end-ip-address $apiappip

$cosmosdbaccount = $resourceName+"Cosmosdbaccount"
az cosmosdb update --name $cosmosdbaccount --resource-group $resourcegroupName --ip-range-filter [$apiappip]


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


read-host "Enter to proceed..."
# # # get webappurl -> put webappurl in readme?

# # # Replace cloud vars in new-project.ps1 + pipeline.yml and push, own file? # uses data after cloud is created

# # # replace temp vars in readme, -> org/subscription?, (project?+add connectionstrings, webappurl and apiurl to readme?)?