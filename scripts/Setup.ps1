#pre
$repoName = "tempRepoName"
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
        # prompt for new project name, 
        # prompt install git
        # clone starter kit,
        # cd starter kit
        # run project-creator
        cd $PWD.Path
        $scriptpath = $PWD.Path + '\project-creator\project-creator.ps1'
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
        ## if not found,
        # prompt install git
        # prompt install Azure CLI
        # clone existing project from $repoName,
        # cd existing project
        ## if found,
        # run tools-installer
        cd $PWD.Path
        while($installTools -ne "x")
        {
            write-host "Choose an option:"
            write-host " - Install developer tools (i)"
            write-host " - Manage existing project (m)"
            write-host " - Exit program (x)"
            $installTools = read-host

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




