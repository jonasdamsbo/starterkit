$gitfolder = "$env:userprofile/Documents/GitHub/"
$starterKitName = "/starterkit"
$orgName = "jonasdamsbo"
$orgFolder = $gitfolder+$orgName
$projFolder = $orgFolder+$starterKitName
$gitClonePath = "https://github.com/"+$orgName+$starterKitName+".git"

Write-Host "starting new"

### if new project
If (Test-Path -Path "$orgFolder" -PathType Container)
{
    Write-Host "Something went wrong, template folder $orgFolder already exists" -ForegroundColor Red
}
ELSE
{
    write-host "reponame: " $projFolder
    Read-Host "Press enter to continue..."

    if(Test-Path -Path "$projFolder" -PathType Container)
    {
        Write-Host "Something went wrong, template folder $projFolder already exists" -ForegroundColor Red
    }
    else
    {
        write-host "Trying to clone starter kit"
        write-host $orgFolder
        git clone $gitClonePath $projFolder --branch "v0.2"
        write-host "Cloned"
        Set-Location $projFolder

        # delete .git ref
        Remove-Item -LiteralPath ".git" -Force -Recurse -erroraction 'silentlycontinue'

        # run project-creator
        Set-Location $PWD.Path
        $scriptpath = $PWD.Path + '\scripts\projectcreator.ps1'
        write-host $scriptpath
        write-host
        & $scriptpath run
    }
}

Read-Host "Enter to proceed..."