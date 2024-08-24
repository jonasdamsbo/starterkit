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

write-host "Trying to replace temp vars in yml pipeline file"
((Get-Content -path azurepipeline.yml -Raw) -replace 'tempsubid',$fullSubId) | Set-Content -Path azurepipeline.yml
((Get-Content -path azurepipeline.yml -Raw) -replace 'tempapiname',$apiappname) | Set-Content -Path azurepipeline.yml
((Get-Content -path azurepipeline.yml -Raw) -replace 'tempwebname',$webappname) | Set-Content -Path azurepipeline.yml
Get-Content -path azurepipeline.yml
Read-Host "Press enter to continue..."

write-host "Trying to create pipeline in azure"
#$ymlPath = $PWD.Path + '\azurepipeline.yml'
az pipelines create --name "testpipeline" --yml-path '\azurepipeline.yml' --detect true
Read-Host "Press enter to continue..."