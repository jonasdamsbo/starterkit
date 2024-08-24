# replace setup script in newRepoName folder 

# replace azureOrg in testazurelogin.ps1
az login
az devops project list --detect true
#az devops project list --org $azureorg

Read-Host "Press enter to continue..."

write-host "Trying to replace tempOrgName in testazurelogin.ps1 file"
((Get-Content -path testazurelogin.ps1 -Raw) -replace 'tempOrgName',$azureOrg) | Set-Content -Path testazurelogin.ps1
Get-Content -path testazurelogin.ps1
Read-Host "Press enter to continue..."

Read-Host "Press enter to continue..."