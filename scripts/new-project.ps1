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
        # prompt install git
        $installGit = "null"
        while($installGit -ne "y" -and $installGit -ne "n")
        {
            $installGit = Read-Host "git is required for the script to run, install git? (y/n)"

            if($installGit -eq "y")
            {
                write-host "Installing git"

                # install git
                $ProgressPreference = 'SilentlyContinue'; 
                Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe -OutFile .\git.exe; 
                Start-Process msiexec.exe -Wait -ArgumentList '/I git.exe /quiet'; 
                Remove-Item .\git.exe

                write-host "Git installed"
            }
            elseif($installGit -eq "n")
            {
                write-host "Skipping git install..."
            }
            else
            {
                write-host "Invalid input"
            }
        }

        write-host "Trying to clone starter kit"
        write-host $orgFolder
        git clone $gitClonePath $projFolder #--branch "v0.4"
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