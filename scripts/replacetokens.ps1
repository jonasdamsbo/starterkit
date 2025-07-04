### params
param (
    [string]$filePath
)

### replace tokens in scripts after terraform before deploy
Write-Host "TOKENS ARE BEING REPLACED"

# get lib vars

    $storagekey = ${env:STORAGEKEY}
    $subscriptionid = ${env:SUBSCRIPTIONID}
    $tenantid = ${env:TENANTID}
    $clientsecret = ${env:CLIENTSECRET}
    $clientid = ${env:CLIENTID}

    $sqlpassword = ${env:SQLPASSWORD}
    $sqllogin = ${env:SQLLOGIN}

    $sqlconnectionstring = ${env:SQLCONNECTIONSTRING}

    $storageaccountname = ${env:STORAGEACCOUNTNAME}

    
    $environmentname = ${env:ENVIRONMENTNAME}

    # to get all values out of tf files and into lib vars
    $terraformcontainer = ${env:TERRAFORMCONTAINER}
    $terraformkey = ${env:TERRAFORMKEY}
    $dbbackupcontainer = ${env:BACKUPCONTAINER}

    # for azureservice
    $pat = ${env:PAT}
    $subscriptionname = ${env:SUBSCRIPTIONNAME}
    $organizationname = ${env:ORGANIZATIONNAME}
    $fullorganizationname = ${env:FULLORGANIZATIONNAME}
    $projectname = ${env:PROJECTNAME}
    $resourcename = ${env:RESOURCENAME}
    $resourcegroupname = ${env:RESOURCEGROUPNAME}

    # for dbbackup
    $storageconnectionstring = ${env:STORAGECONNECTIONSTRING}
    
    $sqlservername = ${env:SQLSERVERNAME}

    
# check lib vars

    write-host "printing env vars from lib vars"

    write-host $storagekey
    write-host $subscriptionid
    write-host $tenantid
    write-host $clientsecret
    write-host $clientid

    write-host $sqlpassword

    write-host $storageconnectionstring

    Write-host $environmentname

    write-host "done printing env vars from lib vars"


# check files before

    # check if classic or yml
    $isclassic = ${env:RELEASE_PRIMARYARTIFACTSOURCEALIAS}
    $myrootpath = "rootpath"
    $terraformpath = "terraformpath"

    if($isclassic)
    {
        # old method for getting paths v works for classic release
        write-host "printing content of main.tf"
        $myrootpath = $PWD.Path
        $terraformpath = Get-ChildItem -Path $myrootpath -Filter 'main.tf' -Recurse -ErrorAction SilentlyContinue |
                        Select-Object -Expand Directory -Unique |
                        Select-Object -Expand FullName
    }
    else 
    {
        # new method to get paths v works for deploy.yml releases
        $myrootpath = $filePath
        $terraformpath = $filePath+"/terraform"
        # new method to get paths ^
    }

    $maintfpath = $terraformpath+"/main.tf"
    $appservicestfpath = $terraformpath+"/appservices.tf"
    $sqldatabasestfpath = $terraformpath+"/sqldatabases.tf"
        


    write-host "path: "$myrootpath
    write-host "path: "$terraformpath

    write-host "path: "$maintfpath
    write-host "path: "$appservicestfpath
    write-host "path: "$sqldatabasestfpath

    write-host (Get-Content -path $maintfpath -Raw)
    write-host "done printing content of main.tf"

write-host "started replacing"

# replace terraform .tf tokens
    
    #replace values
    ((Get-Content -path $maintfpath -Raw) -replace 'tempclientid',$clientid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempclientsecret',$clientsecret) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'temptenantid',$tenantid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempsubscriptionid',$subscriptionid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempstorageaccountname',$storageaccountname) | Set-Content -Path $maintfpath
    ((Get-Content -path $sqldatabasestfpath -Raw) -replace 'tempsqlpassword',$sqlpassword) | Set-Content -Path $sqldatabasestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempsqlpassword',$sqlpassword) | Set-Content -Path $appservicestfpath
    ((Get-Content -path $sqldatabasestfpath -Raw) -replace 'tempsqllogin',$sqllogin) | Set-Content -Path $sqldatabasestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempsqllogin',$sqllogin) | Set-Content -Path $appservicestfpath
    
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempsqlconnectionstring',$sqlconnectionstring) | Set-Content -Path $appservicestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempenvironmentname',$environmentname) | Set-Content -Path $appservicestfpath

    # to get all values out of tf files and into lib vars
    ((Get-Content -path $maintfpath -Raw) -replace 'tempterraformcontainer',$terraformcontainer) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempterraformkey',$terraformkey) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempresourcegroupname',$resourcegroupname) | Set-Content -Path $maintfpath
    ((Get-Content -path $sqldatabasestfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $sqldatabasestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $appservicestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempdbbackupcontainer',$dbbackupcontainer) | Set-Content -Path $appservicestfpath

    ((Get-Content -path $sqldatabasestfpath -Raw) -replace 'tempsqlservername',$sqlservername) | Set-Content -Path $sqldatabasestfpath

    # # for azureservice
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'temppat',$pat) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'temporganizationname',$organizationname) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'tempfullorganizationname',$fullorganizationname) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'tempsubscriptionname',$subscriptionname) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'tempsubscriptionid',$subscriptionid) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'tempclientid',$clientid) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'tempclientsecret',$clientsecret) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'temptenantid',$tenantid) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'tempprojectname',$projectname) | Set-Content -Path $appservicestfpath

    # # for dbbackup
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path $appservicestfpath
    # ((Get-Content -path $appservicestfpath -Raw) -replace 'tempstorageconnectionstring',$storageconnectionstring) | Set-Content -Path $appservicestfpath

    
write-host "done replacing"

# check files after

    write-host "printing content of main.tf"
    write-host (Get-Content -path $maintfpath -Raw)
    write-host "done printing content of main.tf"

    write-host "printing content of appservices.tf"
    write-host (Get-Content -path $appservicestfpath -Raw)
    write-host "done printing content of appservices.tf"

    write-host "printing content of sqldatabases.tf"
    write-host (Get-Content -path $sqldatabasestfpath -Raw)
    write-host "done printing content of sqldatabases.tf"


write-host "TOKENS WAS REPLACED"