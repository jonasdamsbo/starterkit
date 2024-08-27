# remove these when done v
$fullOrgName = "https://dev.azure.com/JonasDamsbo/"
# remove these when done ^

$projectName = ""
$projectExists = "false"
$firstRun = "true"
$bypass = "false"

## prompt desired repo/project name
while(($projectExists -eq "true" -or $firstRun -eq "true") -and $bypass -ne "true")
{
    $firstRun = "false"
    $projectName = read-host "What do you want to name your new project?"
    write-host $projectName"?"
    read-host "(y/n)"
    write-host $fullOrgName$projectName"/"

    ## check if project with name already exists
    #$projectExists = "false"
    $listOfProjects = az devops project show --project $projectName --org $fullOrgName --query "[name]" --output tsv 2>$null
    
    if($listOfProjects -eq $projectName)
    {
        $projectExists = "true"
    }
    else
    {
        $projectExists = "false"
    }

    # compare names of repos with desired name
    write-host $listOfProjects -erroraction 'silentlycontinue'
    write-host $projectExists
    read-host

    # $tempProjectList = $listOfProjects[0]

    # if($tempProjectList.Length -eq 1)
    # {
    #     write-host $listOfProjects
    # }
    # else
    # {
    #     For ($i=0; $i -lt $listOfProjects.Length; $i++)
    #     {
    #         if($listOfProjects[$i] -eq $projectName)
    #         {
    #             $projectExists = "true"
    #         }
    #         write-host $listOfProjects[$i]
    #     }
    # }

    # create project
    if($projectExists -eq "false")
    {
        #az devops project create --name $projectName --org $fullOrgName
        cd ..
        Rename-Item -Path "starter-kit" -NewName $projectName
        cd $projectName
    }
    else
    {
        # while($useExisting -ne "y" -and $useExisting -ne "n")
        # {
        #     #use existing?
        #     $useExisting = read-host "Project already exists, use existing project? (y/n)"
        #     if($useExisting -eq "y")
        #     {
        #         $bypass = "true"
        #     }
        # }
        # $useExisting = ""
    }
}

read-host "Enter to exit..."