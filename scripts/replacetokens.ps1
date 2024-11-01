### replace tokens in scripts after terraform before deploy

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
    $storageaccountname = "$env:STORAGEACCOUNTNAME"
    $storagekey = "$env:STORAGEKEY"
    $dbbackupcontainername = "$env:DBBACKUPCONTAINERNAME"
    $nosqlaccountname = "$env:NOSQLACCOUNTNAME"
    $nosqldatabasename = "$env:NOSQLDATABASENAME"
    $projectname = "$env:PROJECTNAME"
    $storageaccountid = "$env:STORAGEACCOUNTID"
    $resourcegroupid = "$env:RESOURCEGROUPID"
    $pipelineid = "$env:PIPELINEID"
    $projectid = "$env:PROJECTID"
    $repositoryid = "$env:REPOSITORYID"
    $subscriptionid = "$env:SUBSCRIPTIONID"
    $organizationname = "$env:ORGANIZATIONNAME"
    $tenantid = "$env:TENANTID"
    $clientsecret = "$env:CLIENTSECRET"
    $clientid = "$env:CLIENTID"

# replace terraform .tf tokens
    #replace values
    ((Get-Content -path main.tf -Raw) -replace 'tempclientid',$clientid) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempclientsecret',$clientsecret) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'temptenantid',$tenantid) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'temporganizationname',$organizationname) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempsubscriptionid',$subscriptionid) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempprojectname',$projectname) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempazuredevopsprojectid',$projectid) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempazurerepositoryid',$repositoryid) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'temppipelineid',$pipelineid) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempresourcegroupid',$resourcegroupid) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempstorageaccountid',$storageaccountid) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path main.tf
    ((Get-Content -path main.tf -Raw) -replace 'tempterraformcontainername',$storageaccountid) | Set-Content -Path main.tf

    ((Get-Content -path appservices.tf -Raw) -replace 'tempprojectname',$projectname) | Set-Content -Path appservices.tf
    ((Get-Content -path appservices.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path appservices.tf
    ((Get-Content -path appservices.tf -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path appservices.tf
    ((Get-Content -path appservices.tf -Raw) -replace 'tempsqlconnectionstring',$mssqlconnectionstring) | Set-Content -Path appservices.tf
    ((Get-Content -path appservices.tf -Raw) -replace 'tempnosqlconnectionstring',$nosqlconnectionstring) | Set-Content -Path appservices.tf

    ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempprojectname',$projectname) | Set-Content -Path sqldatabases.tf
    ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path sqldatabases.tf

    ((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempprojectname',$projectname) | Set-Content -Path nosqldatabases.tf
    ((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path nosqldatabases.tf

# replace setcloudvars.ps1 tokens
    #replace values
    #((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempnosqlconnectionstring',$nosqlconnectionstring) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempmssqlconnectionstring',$mssqlconnectionstring) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempresourcegroupname',$resourcegroupname) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempwebappname',$webappname) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempapiappname',$apiappname) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempmssqlservername',$mssqlservername) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempmssqldatabasename',$mssqldatabasename) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempstorageaccountname',$storageaccountname) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempdbbackupcontainername',$dbbackupcontainername) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempcosmosdbaccountname',$nosqlaccountname) | Set-Content -Path setcloudvars.ps1
    ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempcosmosmongodbname',$nosqldatabasename) | Set-Content -Path setcloudvars.ps1