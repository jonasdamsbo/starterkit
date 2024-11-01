### replace tokens in scripts after terraform before deploy
Write-Host "TOKENS ARE BEING REPLACED"

# get lib vars
    # get values
    $resourcename = "$env:RESOURCENAME"
    $apiurl = "$env:APIURL"
    $nosqlconnectionstring = "$env:NOSQLCONNECTIONSTRING"
    $mssqlconnectionstring = "$env:MSSQLCONNECTIONSTRING"
    $resourcegroupname = "$env:RESOURCEGROUPNAME"
    $webappname = "$env:WEBAPPNAME"
    $apiappname = "$env:APIAPPNAME"
    $mssqlservername = "$env:MSSQLSERVERNAME"
    $mssqldatabasename = "$env:MSSQLDATABASENAME"
    $storagekey = "$env:STORAGEKEY"
    $dbbackupcontainername = "$env:DBBACKUPCONTAINERNAME"
    $terraformcontainername = "$env:TERRAFORMCONTAINERNAME"
    $nosqlaccountname = "$env:NOSQLACCOUNTNAME"
    $nosqldatabasename = "$env:NOSQLDATABASENAME"
    $projectname = "$env:PROJECTNAME"
    $storageaccountid = "$env:STORAGEACCOUNTID"
    $storageaccountname = "$env:STORAGEACCOUNTNAME"
    $resourcegroupid = "$env:RESOURCEGROUPID"
    $pipelineid = "$env:PIPELINEID"
    $projectid = "$env:PROJECTID"
    $repositoryid = "$env:REPOSITORYID"
    $subscriptionid = "$env:SUBSCRIPTIONID"
    $organizationname = "$env:ORGANIZATIONNAME"
    $tenantid = "$env:TENANTID"
    $clientsecret = "$env:CLIENTSECRET"
    $clientid = "$env:CLIENTID"
    
# check lib vars
    write-host "printing env vars from lib vars"
    write-host $resourcename
    write-host $apiurl
    write-host $nosqlconnectionstring
    write-host $mssqlconnectionstring
    write-host $resourcegroupname
    write-host $webappname
    write-host $apiappname
    write-host $mssqlservername
    write-host $mssqldatabasename
    write-host $storageaccountname
    write-host $storagekey
    write-host $dbbackupcontainername
    write-host $terraformcontainername
    write-host $nosqlaccountname
    write-host $nosqldatabasename
    write-host $projectname
    write-host $storageaccountid
    write-host $resourcegroupid
    write-host $pipelineid
    write-host $projectid
    write-host $repositoryid
    write-host $subscriptionid
    write-host $organizationname
    write-host $tenantid
    write-host $clientsecret
    write-host $clientid
    write-host "done printing env vars from lib vars"

# check files before
    write-host "printing content of main.tf"
    $myrootpath = $PWD.Path
    $terraformpath = Get-ChildItem -Path $myrootpath -Filter 'main.tf' -Recurse -ErrorAction SilentlyContinue |
                     Select-Object -Expand Directory -Unique |
                     Select-Object -Expand FullName

    $scriptspath = Get-ChildItem -Path $myrootpath -Filter 'replacetokens.ps1' -Recurse -ErrorAction SilentlyContinue |
    Select-Object -Expand Directory -Unique |
    Select-Object -Expand FullName

    # $pipelinespath = Get-ChildItem -Path $myrootpath -Filter 'azure-pipelines-destroy.yml' -Recurse -ErrorAction SilentlyContinue |
    # Select-Object -Expand Directory -Unique |
    # Select-Object -Expand FullName

    $maintfpath = $terraformpath+"/main.tf"
    $appservicestfpath = $terraformpath+"/appservices.tf"
    $nosqldatabasestfpath = $terraformpath+"/nosqldatabases.tf"
    $sqldatabasestfpath = $terraformpath+"/sqldatabases.tf"
    $setcloudvarsps1path = $scriptspath+"/setcloudvars.ps1"
    # $azurepipelinesdestroyymlpath = $pipelinespath+"/azure-pipelines-destroy.yml"

    write-host "path: "$myrootpath
    write-host "path: "$terraformpath
    write-host "path: "$scriptspath
    # write-host "path: "$pipelinespath

    write-host "path: "$maintfpath
    write-host "path: "$appservicestfpath
    write-host "path: "$nosqldatabasestfpath
    write-host "path: "$sqldatabasestfpath
    write-host "path: "$setcloudvarsps1path
    # write-host "path: "$azurepipelinesdestroyymlpath

    # write-host "path: "$myrootpath
    # cd ..
    # write-host "path: "$myrootpath
    # cd .terraform
    # write-host "path: "$myrootpath

    write-host (Get-Content -path $maintfpath -Raw)
    write-host "done printing content of main.tf"

    # write-host "printing content of appservices.tf"
    # write-host (Get-Content -path appservices.tf -Raw)
    # write-host "done printing content of appservices.tf"

    # write-host "printing content of sqldatabases.tf"
    # write-host (Get-Content -path sqldatabases.tf -Raw)
    # write-host "done printing content of sqldatabases.tf"

    # write-host "printing content of nosqldatabases.tf"
    # write-host (Get-Content -path nosqldatabases.tf -Raw)
    # write-host "done printing content of nosqldatabases.tf"

    # write-host "printing content of setcloudvars.ps1"
    # write-host (Get-Content -path setcloudvars.ps1 -Raw)
    # write-host "done printing content of setcloudvars.ps1"

write-host "started replacing"

# replace terraform .tf tokens
    #replace values
    ((Get-Content -path $maintfpath -Raw) -replace 'tempclientid',$clientid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempclientsecret',$clientsecret) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'temptenantid',$tenantid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'temporganizationname',$organizationname) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempsubscriptionid',$subscriptionid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempprojectname',$projectname) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempazuredevopsprojectid',$projectid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempazurerepositoryid',$repositoryid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'temppipelineid',$pipelineid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempresourcegroupid',$resourcegroupid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempstorageaccountid',$storageaccountid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempterraformcontainername',$terraformcontainername) | Set-Content -Path $maintfpath

    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempprojectname',$projectname) | Set-Content -Path $appservicestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $appservicestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path $appservicestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempsqlconnectionstring',$mssqlconnectionstring) | Set-Content -Path $appservicestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempnosqlconnectionstring',$nosqlconnectionstring) | Set-Content -Path $appservicestfpath

    ((Get-Content -path $sqldatabasestfpath -Raw) -replace 'tempprojectname',$projectname) | Set-Content -Path $sqldatabasestfpath
    ((Get-Content -path $sqldatabasestfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $sqldatabasestfpath

    ((Get-Content -path $nosqldatabasestfpath -Raw) -replace 'tempprojectname',$projectname) | Set-Content -Path $nosqldatabasestfpath
    ((Get-Content -path $nosqldatabasestfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $nosqldatabasestfpath

# replace setcloudvars.ps1 tokens
    #replace values
    #((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path setcloudvars.ps1

    # cd ..
    # write-host "path: "$myrootpath
    # cd scripts
    # write-host "path: "$myrootpath

    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempnosqlconnectionstring',$nosqlconnectionstring) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempmssqlconnectionstring',$mssqlconnectionstring) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempresourcegroupname',$resourcegroupname) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempwebappname',$webappname) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempapiappname',$apiappname) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempmssqlservername',$mssqlservername) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempmssqldatabasename',$mssqldatabasename) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempstorageaccountname',$storageaccountname) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempdbbackupcontainername',$dbbackupcontainername) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempcosmosdbaccountname',$nosqlaccountname) | Set-Content -Path $setcloudvarsps1path
    ((Get-Content -path $setcloudvarsps1path -Raw) -replace 'tempcosmosmongodbname',$nosqldatabasename) | Set-Content -Path $setcloudvarsps1path


# replace azure-pipelines-destroy.yml tokens
    #replace values
    # ((Get-Content -path $azurepipelinesdestroyymlpath -Raw) -replace 'tempresourcename',$apiurl) | Set-Content -Path $azurepipelinesdestroyymlpath
    # ((Get-Content -path $azurepipelinesdestroyymlpath -Raw) -replace 'tempstorageaccountname',$storageaccountname) | Set-Content -Path $azurepipelinesdestroyymlpath
    # ((Get-Content -path $azurepipelinesdestroyymlpath -Raw) -replace 'tempterraformcontainername',$terraformcontainername) | Set-Content -Path $azurepipelinesdestroyymlpath

    
write-host "done replacing"

# check files after

    # cd ..
    # write-host "path: "$myrootpath
    # cd .terraform
    # write-host "path: "$myrootpath

    write-host "printing content of main.tf"
    write-host (Get-Content -path $maintfpath -Raw)
    write-host "done printing content of main.tf"

    write-host "printing content of appservices.tf"
    write-host (Get-Content -path $appservicestfpath -Raw)
    write-host "done printing content of appservices.tf"

    write-host "printing content of sqldatabases.tf"
    write-host (Get-Content -path $sqldatabasestfpath -Raw)
    write-host "done printing content of sqldatabases.tf"

    write-host "printing content of nosqldatabases.tf"
    write-host (Get-Content -path $nosqldatabasestfpath -Raw)
    write-host "done printing content of nosqldatabases.tf"

    # cd ..
    # write-host "path: "$myrootpath
    # cd scripts
    # write-host "path: "$myrootpath

    write-host "printing content of setcloudvars.ps1"
    write-host (Get-Content -path $setcloudvarsps1path -Raw)
    write-host "done printing content of setcloudvars.ps1"

    # cd ..
    # write-host "path: "$myrootpath
    # cd .azure
    # write-host "path: "$myrootpath

    # write-host "printing content of azure-pipelines-destroy.yml"
    # write-host (Get-Content -path $azurepipelinesdestroyymlpath -Raw)
    # write-host "done printing content of azure-pipelines-destroy.yml"


write-host "TOKENS WAS REPLACED"