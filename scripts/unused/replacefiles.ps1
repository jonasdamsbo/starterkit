# # ### Replace temp vars, uses projectname

# # #New-Variable -Name "subscriptionName" -Visibility Public -Value ""
# # #New-Variable -Name "subscriptionId" -Visibility Public -Value ""

# # #$username = read-host "Type azure username" # "jonasdamsbo@hotmail.com"
# # #$password = read-host "Type azure password" -AsSecureString # "Jones123!321hejlol"

# # #Write-Host "Trying to login"
# # #az login -u $username -p $password
# # #az login # login with prompt, can outcomment username and password on line 4 and 5
# # #Read-Host "Press enter to continue..."
# # # LOGIN IN 'createrpo' and remove from here

# # # Write-Host "Trying to get subid"
# # # $subscriptionId = az account list --query "[?isDefault].id" --output tsv
# # # $subidFormatted = "("+$subscriptionId+")"
# # # $subscriptionName = az account list --query "[?isDefault].name" --output tsv
# # # $fullSubId = $subscriptionName + " " + $subidFormatted
# # # Write-Host $fullSubId
# # # Read-Host "Press enter to continue..."

# # # Write-Host "Trying to get webapp and apiapp ids"
# # # $appservices = az webapp list --query "[?state=='Running'].name" --output tsv
# # # $apiappname = $appservices[0]
# # # $webappname = $appservices[1]
# # # Write-Host $apiappname
# # # Write-Host $webappname
# # # Read-Host "Press enter to continue..."

### replace pipeline # replace temp vars in pipeline files with projectname -> fullsubid+webappname+apiappname
write-host "Replacing vars in azure-pipelines.yml"
# # # $subscriptionId = az account list --query "[?isDefault].id" --output tsv
# # # $subidFormatted = "("+$subscriptionId+")"
# # # $subscriptionName = az account list --query "[?isDefault].name" --output tsv
# # # $fullSubId = $subscriptionName + " " + $subidFormatted

# # # replace pipeline.yml vars fullsubid+webappname+apiappname
# # # write-host "Trying to replace temp vars in yml pipeline file"
# # # ((Get-Content -path azurepipeline.yml -Raw) -replace 'tempsubid',$fullSubId) | Set-Content -Path azurepipeline.yml
# # # ((Get-Content -path azurepipeline.yml -Raw) -replace 'tempapiname',$apiappname) | Set-Content -Path azurepipeline.yml
# # # ((Get-Content -path azurepipeline.yml -Raw) -replace 'tempwebname',$webappname) | Set-Content -Path azurepipeline.yml
# # # Get-Content -path azurepipeline.yml
cd "./.azure/"

# replace tempsubid with $fullSubId
((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempsubscriptionid',$fullSubId) | Set-Content -Path azure-pipelines.yml

((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path azure-pipelines.yml
((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempstorageaccount',$storageaccountName) | Set-Content -Path azure-pipelines.yml

# replace tempapiname with $apiappname
$apiappname = $resourceName+"Apiapp"
((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempapiappname',$apiappname) | Set-Content -Path azure-pipelines.yml

# replace tempwebname with $webappname
$webappname = $resourceName+"Webapp"
((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempwebappname',$webappname) | Set-Content -Path azure-pipelines.yml

cd ..

Read-Host "Press enter to continue..."


### replace cloud # replace temp vars in terraform files in project/.terraform folder with projectname, + subscription&organization, + principalname?, 
write-host "Replacing vars in *.tf"
cd "./.terraform/"

# replace temporganizationname with $fullOrgName in main.tf
((Get-Content -path main.tf -Raw) -replace 'temporganizationname',$fullOrgName) | Set-Content -Path main.tf

# replace tempsubscriptionid with $fullSubId in main.tf
((Get-Content -path main.tf -Raw) -replace 'tempsubscriptionid',$fullSubId) | Set-Content -Path main.tf

# replace tempprincipalname with $principalname in repositories.tf
# $principalname = $resourceName
# ((Get-Content -path repositories.tf -Raw) -replace 'tempprincipalname',$principalname) | Set-Content -Path repositories.tf

# replace tempprojectname with $projectName in *.tf
((Get-Content -path main.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path main.tf
((Get-Content -path appservices.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path appservices.tf
((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path nosqldatabases.tf
((Get-Content -path sqldatabases.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path sqldatabases.tf
# ((Get-Content -path pipelines.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path pipelines.tf
# ((Get-Content -path repositories.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path repositories.tf

    # replace repo, pipeline, resourcegroup, storageaccount... tempresourcename with $resourceName in *.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path main.tf
    ((Get-Content -path appservices.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path appservices.tf
    ((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path nosqldatabases.tf
    ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path sqldatabases.tf

    ## replace tempids with $*id in main.tf

    #tempazuredevopsprojectid
    ((Get-Content -path main.tf -Raw) -replace 'tempazuredevopsprojectid',$projectid) | Set-Content -Path main.tf

    #tempazurerepositoryid
    ((Get-Content -path main.tf -Raw) -replace 'tempazurerepositoryid',$repositoryId) | Set-Content -Path main.tf

    #temppipelineid
    ((Get-Content -path main.tf -Raw) -replace 'temppipelineid',$pipelineId) | Set-Content -Path main.tf

    #tempresourcegroupid
    ((Get-Content -path main.tf -Raw) -replace 'tempresourcegroupid',$resourcegroupId) | Set-Content -Path main.tf

    #tempstorageaccountid and tempstoragekey
    ((Get-Content -path main.tf -Raw) -replace 'tempstorageaccountid',$storageaccountId) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path main.tf


    ### replace apiurl and constrs, can be done in refreshcloudips.ps1
    # get and add apiurl for webapp
    $apiurl = $resourceName+"Apiapp.azurewebsites.net"
    $webappname = $resourcename+"Webapp"
    ((Get-Content -path appservices.tf -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path appservices.tf

    # get and add mongodb and mssqldb connectionstrings for apiapp
    $nosqlconnectionstring = "mongodb+srv://"+$resourceName+":'P4ssw0rd'@"+$resourceName+"cosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"

    $sqlconnectionstring = "Server=tcp:"+$resourceName+"sqldbserver.database.windows.net,1433;Initial Catalog="+$resourceName+"sqldb;Persist Security Info=False;User ID="+$resourceName+";Password=P@ssw0rd;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    $apiappname = $resourcename+"Apiapp"
    ((Get-Content -path appservices.tf -Raw) -replace 'tempsqlconnectionstring',$sqlconnectionstring) | Set-Content -Path appservices.tf #
    ((Get-Content -path appservices.tf -Raw) -replace 'tempnosqlconnectionstring',$nosqlconnectionstring) | Set-Content -Path appservices.tf

cd ..

# # # Can you create subscription+billingaccount+billingprofile+invoicesection with terraform?
# # # find billingaccount, billingprofile and invoicesection
# # # az billing account list
# # # az billing profile list --account-name 086682b6-a4b1-57e9-5bdd-62806d3dc3c0:b4ca7cb9-8c50-4b0c-9347-e7cbccca336f_2019-05-31
# # # az billing invoice section list --account-name 086682b6-a4b1-57e9-5bdd-62806d3dc3c0:b4ca7cb9-8c50-4b0c-9347-e7cbccca336f_2019-05-31 --profile-name M3E4-IYP6-BG7-PGB
# # # replace billingaccount, billingprofile and invoicesection in main.tf
# # # az account create --enrollment-account-name --offer-type {MS-AZR-0017P, MS-AZR-0148P, MS-AZR-USGOV-0015P, MS-AZR-USGOV-0017P, MS-AZR-USGOV-0148P}

Read-Host "Press enter to continue..."


### replace old-project # (tempprojectname with $projectName & temporganizationname with $orgName) in old-project script in new folder # azuregit etc?, 
write-host "Replacing vars in old-project.ps1"
cd "./scripts/"

# replace tempprojectname with $projectName
((Get-Content -path old-project.ps1 -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path old-project.ps1

# replace temporganizationname with $orgName
((Get-Content -path old-project.ps1 -Raw) -replace 'temporganizationname',$orgName) | Set-Content -Path old-project.ps1

#replace resourcename in refreshcloudips.ps
((Get-Content -path refreshcloudips.ps1 -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path refreshcloudips.ps1

cd ..


## Replacing branch-policy vars
write-host "Replacing vars in branch-policy.json"
cd "./.azure/"

# replace tempprojectname with $projectName
((Get-Content -path branch-policy.json -Raw) -replace 'temprepositoryid',$repositoryId) | Set-Content -Path branch-policy.json

cd ..

# # # replace tempazureorgit with $azureorgit

# # # replace azureOrg in testazurelogin.ps1
# # # az login
# # # az devops project list --detect true
# # # az devops project list --org $azureorg

# # # Read-Host "Press enter to continue..."

# # # write-host "Trying to replace tempOrgName in testazurelogin.ps1 file"
# # # ((Get-Content -path testazurelogin.ps1 -Raw) -replace 'tempOrgName',$azureOrg) | Set-Content -Path testazurelogin.ps1
# # # Get-Content -path testazurelogin.ps1
# # # Read-Host "Press enter to continue..."

Read-Host "Press enter to continue..."