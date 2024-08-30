## prompt to enter organisation name name
#az login
$orgExists = "false"
while($orgExists -eq "false")
{
    $orgName = read-host "What is the name your Azure DevOps organization?" # used to check project and repo name before accepting chosen projectname, and git init
    write-host $orgName"?"
    read-host "(y/n)"
    $fullOrgName = "https://dev.azure.com/"+$orgName+"/"
    $fullOrgName = $fullOrgName.Replace(" ","")
    write-host $fullOrgName

    # test if org exists v
    write-host "Checking if organization exists..."
    $statusCode = ""
    $statusCode = az devops project create --name lolsjgdhej --organization $fullOrgName --output tsv 2>$null
    #write-host "Statuscode: $statusCode 123"
    if($statusCode.Length -lt 1)
    {
        write-host "organization does not exist..."
    }
    else
    {
        $orgExists = "true"
        write-host "organization exists..."
    }
    
    write-host "Done checking if organization exists..."
    read-host "Enter to proceed..."
}

$tempProjectId = az devops project show --project lolsjgdhej --organization $fullOrgName --query "[id]" --output tsv 2>$null
#write-host "Tempid: "$tempProjectId
$tempProjectId = $tempProjectId.Replace("]","")
$tempProjectId = $tempProjectId.Replace("[","")
$tempProjectId = $tempProjectId.Replace(" ","")
#write-host "Tempid: $tempProjectId"
$statusCode = az devops project delete --id $tempProjectId --organization $fullOrgName -y --output tsv 2>$null
#write-host "Statuscode: $statusCode 321"
read-host "Enter to proceed..."
# test if found exists ^

cd ..
cd ..
Rename-Item -Path "starter-kit-org" -NewName $orgName
cd $orgName
cd "starter-kit"

read-host "Enter to exit..."