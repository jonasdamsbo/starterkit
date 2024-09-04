#pre
$projectName = "tempprojectname"
$orgName = "temporganizationname"
$azureorgit = ""

$setupPath = $PWD.Path
$projectType = ""
$gitfolder = "$env:userprofile/Documents/GitHub/"
$repofolder = $gitfolder+$orgName #+"repo"
$newProjOrgFolder = $gitfolder+"starter-kit-org"
#$tempRepofolder = $gitfolder+"temporganizationname"

while($projectType -ne "new" -and $projectType -ne "old")
{
    # prompt existing project or create new project
    $tempProjectType = read-host "Setup existing project or create a new project? (old/new)"

    if($tempProjectType -eq "new")
    {
        Write-Host "starting new"
        $projectType = $tempProjectType

        ### if new project, 
        If (Test-Path -Path "$newProjOrgFolder" -PathType Container)
        { Write-Host "Something went wrong, template folder $newProjOrgFolder already exists" -ForegroundColor Red}
        ELSE
        {
            # prompt install git <-- remove?
            
            ## start download
            $gitFileUri = "https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe"
            $gitInstallPath = $PWD.Path+"gitinstaller.exe"
            $bitsJobObj = Start-BitsTransfer $gitFileUri -Destination $gitInstallPath
            switch ($bitsJobObj.JobState) {

                'Transferred' {
                    Complete-BitsTransfer -BitsJob $bitsJobObj
                    break
                }

                'Error' {
                    throw 'Error downloading'
                }
            }

            ## start install
            $exeArgs = '/verysilent /tasks=addcontextmenufiles,addcontextmenufolders,addtopath'
            Start-Process -Wait $gitInstallPath -ArgumentList $exeArgs

            # remove installer
            rm -Force "$gitInstallPath"

            ## prompt install azure cli <-- remove?

            # install azure cli
            write-host "Started instaling Azure CLI"
            $ProgressPreference = 'SilentlyContinue'; 
            Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; 
            Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; 
            Remove-Item .\AzureCLI.msi
            read-host "finished installing Azure CLI"

            ## clone starter kit to new project name folder
            #Param($newRepoName)
            write-host "reponame: " $projectName #$args[1]
            Read-Host "Press enter to continue..."

            write-host "Trying to clone starter kit"
            write-host $newProjOrgFolder
            git clone https://github.com/jonasdamsbo/mywebrepo.git $newProjOrgFolder
            write-host "Cloned"

            # cd folder
            cd $newProjOrgFolder
            cd "mywebrepo" # change to starter-kit when done

            # delete .git ref
            Remove-Item -LiteralPath ".git" -Force -Recurse -erroraction 'silentlycontinue'
            Remove-Item -LiteralPath ".git" -Force -Recurse -erroraction 'silentlycontinue'

            write-host "Would you like to use."
            write-host " - Azure DevOps Repos and Pipelines"
            write-host " - or"
            write-host " - GitHub and GitHub Actions?"
            $azureorgit = read-host "(azure/github)"

            # run project-creator
            cd $PWD.Path
            $scriptpath = $PWD.Path + '\project-creator.ps1'
            write-host $scriptpath
            write-host
            & $scriptpath run
        }

        Read-Host "Enter to proceed..."
    }
    elseif($tempProjectType -eq "old")
    {
        Write-Host "starting old"
        $projectType = $tempProjectType
        $gitfolder = "$env:userprofile/Documents/GitHub/"
        $repofolder = $gitfolder+$orgName #+"repo"
        write-host $repofolder

        ### if existing project, 
        ## if folder not found,
        If (Test-Path -Path "$repofolder" -PathType Container)
        { Write-Host "Folder $repofolder already exists" -ForegroundColor Red}
        ELSE
        {
            #New-Item -Path "$repofolder" -ItemType directory
            #Write-Host "Folder $repofolder directory created" -ForegroundColor Green

            # prompt install git? <-- remove?

            # install git
            $ProgressPreference = 'SilentlyContinue'; 
            Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe -OutFile .\git.exe; 
            Start-Process msiexec.exe -Wait -ArgumentList '/I git.exe /quiet'; 
            Remove-Item .\git.exe

            # clone existing project from $repoName,
            write-host "Trying to clone existing project"
            if($azureorgit -eq "azure")
            {
                # azure repo clone
                git clone "https://"+"$orgName"+"@dev.azure.com/"+"$orgName"+"/"+"$projectName"+"/_git/"+"$projectName"+"Azurerepository" $repofolder
            }
            else
            {
                # github clone
                git clone https://github.com/+"$orgName"+"/"+"$projectName"+".git" $repofolder
            }
            write-host "Cloned"
            
            # cd existing project
            cd $repofolder
            cd $projectName
        }

        ## if found,
        cd $PWD.Path

        while($installTools -ne "x")
        {
            write-host "Choose an option:"
            write-host " - Install developer tools (i)"
            write-host " - Manage existing project (m)"
            write-host " - Exit program (x)"
            $installTools = read-host

            
            # run tools-installer or resource-manager
            if($installTools -eq "i")
            {
                $scriptpath = $PWD.Path + '\tools-installer.ps1'
                write-host $scriptpath
                write-host
                read-host "Developer tools script will run"
                & $scriptpath run
            }
            elseif($installTools -eq "m")
            {
                # prompt install Azure CLI
                $scriptpath = $PWD.Path + '\resource-manager.ps1'
                write-host $scriptpath
                write-host
                read-host "Project manager script will run"
                & $scriptpath run
            }
            elseif($installTools -eq "x")
            {
                write-host "Program will exit"
            }
        }
        Read-Host "Enter to proceed..."
    }
}




