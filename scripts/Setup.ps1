#pre
$repoName = "tempRepoName"
$projectType = "";

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
        # clone starter kit,
        # cd starter kit
        # run project-creator
        cd $PWD.Path
        $scriptpath = $PWD.Path + '\project-creator.ps1'
        & $scriptpath run

        Read-Host "Enter to exit..."
    }
    elseif($tempProjectType -eq "old")
    {
        Write-Host "starting old"
        $projectType = $tempProjectType

        ### if existing project, 
        ## if not found,
        # clone existing project from $repoName,
        # cd existing project
        ## if found,
        # run tools-installer
        cd $PWD.Path
        $scriptpath = $PWD.Path + '\tools-installer.ps1'
        & $scriptpath run

        Read-Host "Enter to exit..."
    }
}




