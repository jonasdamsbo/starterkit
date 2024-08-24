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
        # clone existing project from $repoName,
        # cd existing project
        ## if found,
        # run tools-installer
        cd $PWD.Path
        while($installTools -ne "yes" -and $installTools -ne "no")
        {
            $installTools = read-host "Install developer tools? (yes/no)"
            if($installTools -eq "yes")
            {
                $scriptpath = $PWD.Path + '\tools-installer.ps1'
                write-host $scriptpath
                write-host
                & $scriptpath run
            }
        }
        Read-Host "Enter to proceed..."
    }
}




