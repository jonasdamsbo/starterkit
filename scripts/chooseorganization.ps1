## prompt to enter organisation name name
az login
$orgName = read-host "What is the name your Azure DevOps organization?" # used to check project and repo name before accepting chosen projectname, and git init
write-host $orgName"?"
read-host "(y/n)"
$fullOrgName = "https://dev.azure.com/"+$orgName+"/"
$fullOrgName = $fullOrgName.Replace(" ","")
write-host $fullOrgName

cd ..
cd ..
Rename-Item -Path "tempRepoName" -NewName $orgName
cd $orgName
cd "starter-kit"

read-host "Enter to exit..."