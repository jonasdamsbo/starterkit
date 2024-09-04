# # remove these when done v
# $fullOrgName = "https://dev.azure.com/JonasDamsbo/"
# # remove these when done ^

$projectName = ""
$projectExists = "false"
$firstRun = "true"
$bypass = "false"

## prompt desired repo/project name
while((($projectExists -eq "true" -or $resourcegroupExists -eq "true") -or $firstRun -eq "true") -and $bypass -ne "true")
{
    $firstRun = "false"
    $projectName = read-host "What do you want to name your new project?"
    write-host $projectName"?"
    read-host "(y/n)"
    write-host $fullOrgName$projectName"/"

    ## check if project with name already exists
    write-host "Checking if project exists..."
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

    

    write-host $listOfProjects -erroraction 'silentlycontinue'
    write-host $projectExists

    # create project
    if($projectExists -eq "false")
    {
        write-host "fullorgname: "$fullOrgName
        $statusProj = az devops project create --name $projectName --organization $fullOrgName --output tsv 2>$null
        #$projectId = az devops project create --name $projectName --organization $fullOrgName --query "[id]" --output tsv
        write-host $statusProj #$projectId
        $projectId = az devops project show --project $projectName --org $fullOrgName --query "[id]" --output tsv 2>$null
        write-host $projectId
        
        write-host "Project name can be used"
        # cd ..
        # Rename-Item -Path "starter-kit" -NewName $projectName # change to 'starter-kit' when done
        # cd $projectName

        # create project, resourcegroup, storageaccount, repository (, pipeline?) -> remove from .tf. This way terraform can freely destroy/create
    }
    elseif($projectExists -eq "true")
    {
        #read-host "Project already exists, rename existing project in azure devops or choose another project name"
        while($useExisting -ne "y" -and $useExisting -ne "n")
        {
            #use existing?
            $useExisting = read-host "Project already exists, use existing project? (y/n)"
            if($useExisting -eq "y")
            {
                $projectId = az devops project show --project $projectName --org $fullOrgName --query "[id]" --output tsv 2>$null
                write-host $projectId
                #$projectId = az devops project create --name $projectName --organization $fullOrgName --query "[id]" --output tsv
                $bypass = "true"
            }
        }
        $useExisting = ""
    }
    # elseif($resourcegroupExists -eq "true" -and $projectExists -eq "false")
    # {
    #     read-host "Resourcegroup already exists, rename existing resourcegroup in azure portal or choose another project name"
    # }
    # elseif($resourcegroupExists -eq "true" -and $projectExists -eq "true")
    # {
    #     read-host "Resourcegroup and project already exists, rename existing resourcegroup and project in azure portal and azure devops, or choose another project name"
    # }
    write-host "Done checking if project..."
}

read-host "Enter to exit..."