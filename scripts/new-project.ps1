$gitfolder = "$env:userprofile/Documents/GitHub/"
$starterKitName = "/starterkit"
$orgName = "jonasdamsbo"
$orgFolder = $gitfolder+$orgName #$gitfolder+"starter-kit-org"
$projFolder = $orgFolder+$starterKitName #$orgFolder+"/starter-kit"
$gitClonePath = "https://github.com/"+$orgName+$starterKitName+".git"

Write-Host "starting new"

### if new project, 
If (Test-Path -Path "$orgFolder" -PathType Container)
{
    Write-Host "Something went wrong, template folder $orgFolder already exists" -ForegroundColor Red
}
ELSE
{
    # # prompt install git <-- remove?
    
    # ## start download
    # $gitFileUri = "https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe"
    # $gitInstallPath = $PWD.Path+"gitinstaller.exe"
    # $bitsJobObj = Start-BitsTransfer $gitFileUri -Destination $gitInstallPath
    # switch ($bitsJobObj.JobState) {

    #     'Transferred' {
    #         Complete-BitsTransfer -BitsJob $bitsJobObj
    #         break
    #     }

    #     'Error' {
    #         throw 'Error downloading'
    #     }
    # }

    # ## start install
    # $exeArgs = '/verysilent /tasks=addcontextmenufiles,addcontextmenufolders,addtopath'
    # Start-Process -Wait $gitInstallPath -ArgumentList $exeArgs

    # # remove installer
    # rm -Force "$gitInstallPath"

    # ## prompt install azure cli <-- remove?

    # # install azure cli
    # write-host "Started instaling Azure CLI"
    # $ProgressPreference = 'SilentlyContinue'; 
    # Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; 
    # Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; 
    # Remove-Item .\AzureCLI.msi
    # read-host "finished installing Azure CLI"

    ## clone starter kit to new project name folder
    #Param($newRepoName)
    write-host "reponame: " $projFolder #$args[1]
    Read-Host "Press enter to continue..."

    if(Test-Path -Path "$projFolder" -PathType Container)
    {
        Write-Host "Something went wrong, template folder $projFolder already exists" -ForegroundColor Red
    }
    else
    {
        #New-Item -Path "$gitfolder" -Name "starter-kit-org" -ItemType "directory"
        write-host "Trying to clone starter kit"
        write-host $orgFolder
        git clone $gitClonePath $projFolder #git clone https://github.com/jonasdamsbo/starterkit.git $projFolder
        write-host "Cloned"

        # cd folder
        #cd $orgFolder
        cd $projFolder # change to 'starter-kit' when done

        # delete .git ref
        Remove-Item -LiteralPath ".git" -Force -Recurse -erroraction 'silentlycontinue'
        Remove-Item -LiteralPath ".git" -Force -Recurse -erroraction 'silentlycontinue'

        # write-host "Would you like to use."
        # write-host " - Azure DevOps Repos and Pipelines"
        # write-host " - or"
        # write-host " - GitHub and GitHub Actions?"
        # $azureorgit = read-host "(azure/github)"

        # run project-creator
        cd $PWD.Path
        $scriptpath = $PWD.Path + '\scripts\projectcreator.ps1'
        write-host $scriptpath
        write-host
        & $scriptpath run
    }
}

Read-Host "Enter to proceed..."