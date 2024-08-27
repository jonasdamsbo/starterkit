# prompt azure devops login
Write-Host "Trying to login"
#az login
Write-Host "Make sure you have access to portal.azure.com and have made an organization on dev.azure.com"
Read-Host "Press enter to continue..."

# remove these when done v
$projectName = "azuremy"
$fullOrgName = "https://dev.azure.com/JonasDamsbo/"
# remove these when done ^


# check if repo with name already exists
$listOfRepos = az repos list --query "[].name" --org $fullOrgName --output tsv

$repoName = $projectName+"repo"
$repoExists = "false"
$gitfolder = "$env:userprofile/Documents/GitHub/"
$repofolder = $gitfolder+$repoName
write-host $repofolder

# compare names of repos with desired name
write-host $listOfRepos.Length
$tempRepoList = $listOfRepos[0]

if($tempRepoList.Length -eq 1)
{
    write-host $listOfRepos
}
else
{
    For ($i=0; $i -lt $listOfRepos.Length; $i++)
    {
        if($listOfRepos[$i] -eq $repoName)
        {
            $repoExists = "true"
        }
        write-host $listOfRepos[$i]
    }
}

# create repo and sub if name doesnt exist
if($repoExists -eq "false")
{
    # read from repo template?

    # create repo with newRepoName from clonestarterkit.ps1
    write-host "Creating repo"

    $repoDetails = az repos create --name $repoName --org $fullOrgName --output json
    write-host $repoDetails
    #write-host $repoDetails.objects.webUrl
    write-host
    $AppIds = $repoDetails | ConvertFrom-Json
    write-host $AppIds
    write-host
    # $AppId = $AppIds[0]
    # write-host $AppIds.objects.webUrl
    # write-host
    # write-host $AppId
    # write-host
    # $noSpaceDetails = $repoDetails.replace('"','')
    # $noSpaceDetails2 = $noSpaceDetails.replace(' ','')
    # write-host $noSpaceDetails
    # write-host $noSpaceDetails2
    # write-host
    # write-host $noSpaceDetails2.objects.webUrl
    # write-host 
    # write-host $noSpaceDetails2."webUrl"

    $someStrings = $AppIds -Split "webUrl="
    $someString = $someStrings[1]
    $someString2 = $someString.Trim("}")
    write-host $someString2
    # $length = $repoDetails.Length-1
    # $tempo = $repoDetails[$length]
    # write-host $tempo
    # write-host 

    # $repoDetails = az repos create --name $repoName --detect true --output json
    # $noSpaceDetails = $repoDetails.replace(' ','')
    # write-host 
    # write-host $repoDetails
    # write-host 
    # write-host $noSpaceDetails
    # write-host
    # $teemp = $repoDetails.'"webUrl"'
    # $teemp2 = $noSpaceDetails.'"webUrl"'
    # $teemp3 = $noSpaceDetails."webUrl"
    # write-host $teemp
    # write-host $teemp2
    # write-host $teemp3

    # $leng = $repoDetails.Length
    # $indx = $leng-1
    # $valu = $repoDetails[$indx]
    # write-host $valu
    write-host 
    #$key = "webUrl"
    #write-host $repoDetails.$key

    read-host "Pushing project til repo"

    ## Init new repo
    
    # clone repo
    git clone $someString2 $repofolder

    # copy projectfolder to repo folder, starterkit repo contents->new repo cntents


    read-host "Repo created!"

}
else
{
    write-host "Repo name already exists"
}

read-host

