#New-Variable -Name "subscriptionName" -Visibility Public -Value ""
#New-Variable -Name "subscriptionId" -Visibility Public -Value ""

#$username = read-host "Type azure username" # "jonasdamsbo@hotmail.com"
#$password = read-host "Type azure password" -AsSecureString # "Jones123!321hejlol"

Write-Host "Trying to login"
#az login -u $username -p $password
#az login # login with prompt, can outcomment username and password on line 4 and 5
Read-Host "Press enter to continue..."
# LOGIN IN 'createrpo' and remove from here

Write-Host "Trying to get subid"
$subscriptionId = az account list --query "[?isDefault].id" --output tsv
$subidFormatted = "("+$subscriptionId+")"
$subscriptionName = az account list --query "[?isDefault].name" --output tsv
$fullSubId = $subscriptionName + " " + $subidFormatted
Write-Host $fullSubId
Read-Host "Press enter to continue..."

Write-Host "Trying to get webapp and apiapp ids"
$appservices = az webapp list --query "[?state=='Running'].name" --output tsv
$apiappname = $appservices[0]
$webappname = $appservices[1]
Write-Host $apiappname
Write-Host $webappname
Read-Host "Press enter to continue..."

# replace pipeline # replace temp vars in pipeline files with projectname
    write-host "Trying to replace temp vars in yml pipeline file"
    ((Get-Content -path azurepipeline.yml -Raw) -replace 'tempsubid',$fullSubId) | Set-Content -Path azurepipeline.yml
    ((Get-Content -path azurepipeline.yml -Raw) -replace 'tempapiname',$apiappname) | Set-Content -Path azurepipeline.yml
    ((Get-Content -path azurepipeline.yml -Raw) -replace 'tempwebname',$webappname) | Set-Content -Path azurepipeline.yml
    Get-Content -path azurepipeline.yml

Read-Host "Press enter to continue..."

# replace cloud # replace temp vars in terraform files with projectname
    # replace terraform script in newRepoName folder 
    # find billingaccount, billingprofile and invoicesection
        # az billing account list
        # az billing profile list --account-name 086682b6-a4b1-57e9-5bdd-62806d3dc3c0:b4ca7cb9-8c50-4b0c-9347-e7cbccca336f_2019-05-31
        # az billing invoice section list --account-name 086682b6-a4b1-57e9-5bdd-62806d3dc3c0:b4ca7cb9-8c50-4b0c-9347-e7cbccca336f_2019-05-31 --profile-name M3E4-IYP6-BG7-PGB
        
    # replace billingaccount, billingprofile and invoicesection in terraform

Read-Host "Press enter to continue..."

# replace setup
    # replace setup script in newRepoName folder 

    # replace azureOrg in testazurelogin.ps1
    #az login
    #az devops project list --detect true
    #az devops project list --org $azureorg

    # Read-Host "Press enter to continue..."

    # write-host "Trying to replace tempOrgName in testazurelogin.ps1 file"
    # ((Get-Content -path testazurelogin.ps1 -Raw) -replace 'tempOrgName',$azureOrg) | Set-Content -Path testazurelogin.ps1
    # Get-Content -path testazurelogin.ps1
    # Read-Host "Press enter to continue..."

Read-Host "Press enter to continue..."

# replace repo

Read-Host "Press enter to continue..."