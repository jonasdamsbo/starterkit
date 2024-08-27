#pre
$projectName = "tempRepoName"
$orgName = "tempOrgName"
$setupPath = $PWD.Path
$projectType = ""

while($projectType -ne "new" -and $projectType -ne "old")
{
    # prompt existing project or create new project
    $tempProjectType = read-host "Setup existing project or create a new project? (old/new)"

    if($tempProjectType -eq "new")
    {
        Write-Host "starting new"
        $projectType = $tempProjectType

        ### if new project, 
        # prompt install git


        # prompt install azure cli


        # clone starter kit to new project name folder
        #Param($newRepoName)
        write-host "reponame: " $projectName #$args[1]
        Read-Host "Press enter to continue..."

        write-host "Trying to clone starter kit"
        $gitfolder = "$env:userprofile/Documents/GitHub/"
        $repofolder = $gitfolder+$orgName #+"repo"
        write-host $repofolder
        git clone https://github.com/jonasdamsbo/mywebrepo.git $repofolder
        write-host "Cloned"

        # cd folder
        cd $repofolder
        cd "starter-kit"

        # delete .git ref
        Remove-Item -LiteralPath ".git" -Force -Recurse -erroraction 'silentlycontinue'
        Remove-Item -LiteralPath ".git" -Force -Recurse -erroraction 'silentlycontinue'

        # run project-creator
        cd $PWD.Path
        $scriptpath = $PWD.Path + '\project-creator.ps1'
        write-host $scriptpath
        write-host
        & $scriptpath run

        Read-Host "Enter to proceed..."
    }
    elseif($tempProjectType -eq "old")
    {
        Write-Host "starting old"
        $projectType = $tempProjectType

        ### if existing project, 
        ## if folder not found,


        # prompt install git


        # clone existing project from $repoName,
        write-host "Trying to clone existing project"
        $gitfolder = "$env:userprofile/Documents/GitHub/"
        $repofolder = $gitfolder+$orgName #+"repo"
        write-host $repofolder
        git clone https://github.com/+"$orgName"+"/"+"$projectName"+".git" $repofolder
        write-host "Cloned"

        # cd existing project
        cd $repofolder
        cd $projectName

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




