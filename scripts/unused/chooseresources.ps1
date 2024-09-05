while($resourcegroupExists -eq "true" -or $repositoryExists -eq "true" -or $pipelineExists -eq "true" -or $storageaccountExists -eq "true")
{
    #choose resource name
    write-host "What would you like to call your resources?"
    write-host "   - repository, pipeline, resourcegroup, webapp, api, databases, storageaccount"
    write-host "   - ex: if you enter 'myresources', the repository will be named myresourcesRepository"
    $resourceName = read-host ""

    ## check if resourcegroup exists
    write-host "Checking if resourcegroup exists..."
    $resourcegroupName = $resourceName+"Resourcegroup"
    $resourcegroupExists = "false"
    $listOfResourcegroups = az group show --name $resourcegroupName --query "[name]" --output tsv 2>$null

    if($listOfResourcegroups -eq $resourcegroupName)
    {
        $resourcegroupExists = "true"
    }
    else
    {
        $resourcegroupExists = "false"
        $storageaccountExists = "false"
    }

    write-host "Done checking if resourcegroup exists..."
    write-host

    if($resourcegroupExists)
    {
        ## check if resourcegroup exists
        write-host "Checking if storageaccount exists..."
        $storageaccountName = $resourceName+"Storageaccount"
        $storageaccountExists = "false"
        $listOfStorageaccount = az storage account show -g $resourcegroupName -n $storageaccountName --query "[name]" --output tsv 2>$null

        if($listOfStorageaccount -eq $storageaccountName)
        {
            $storageaccountExists = "true"
        }
        else
        {
            $storageaccountExists = "false"
        }

        write-host "Done checking if resourcegroup exists..."
        write-host
    }

    # check if repository exists
    write-host "Checking if repository exists..."
    $repositoryName = $resourceName+"Repository"
    $repositoryExists = "false"
    $listOfRepositories = az repos show -r $repositoryName --org $fullOrgName --query "[name]" --output tsv 2>$null

    if($listOfRepositories -eq $repositoryName)
    {
        $repositoryExists = "true"
    }
    else
    {
        $repositoryExists = "false"
    }

    write-host "Done checking if repository exists..."
    write-host

    # check if pipeline exists
    write-host "Checking if pipeline exists..."
    $pipelineName = $resourceName+"Pipeline"
    $pipelineExists = "false"
    $listOfPipelines = az pipelines show --name $pipelineName --org $fullOrgName --query "[name]" --output tsv 2>$null

    if($listOfPipelines -eq $pipelineName)
    {
        $pipelineExists = "true"
    }
    else
    {
        $pipelineExists = "false"
    }

    write-host "Done checking if pipeline exists..."
    write-host

    # create resources if resource names dont already exist, else retry
    if($resourcegroupExists -eq "false" -and $repositoryExists -eq "false" -and $pipelineExists -eq "false" -and $storageaccountExists -eq "false")
    {
        # create resources
        read-host "Creating resources..."

        # create repo - 
        #$repoDetails = az repos create --name $repositoryName --org $fullOrgName --output json
        #write-host $repoDetails
        $repositoryId = az repos create --name $repositoryName --org $fullOrgName --project $projectName --output json --query "[id]"
        write-host $repositoryId

        # create pipeline
        #$pipelineDetails = az pipelines create --name $pipelinename --yml-path '\.azure\azure-pipelines.yml' --org $fullOrgName --repository-type "tfsgit" --repository $repositoryName
        $pipelineId = az pipelines create --name $pipelinename --yml-path '\.azure\azure-pipelines.yml' --org $fullOrgName --project $projectName --repository-type "tfsgit" --repository $repositoryName --output json --query "[id]"
        write-host $pipelineId

        # create resourcegroup
        #$rgDetails = az group create -l "northeu" -n $resourcegroupName
        $resourcegroupId = az group create -l "northeu" -n $resourcegroupName --output json --query "[id]"
        write-host $resourcegroupId

        # create storageaccount and container
        #$saDetails = az storage account create -l "northeu" -n $storageaccountName -g $resourcegroupName
        $storageaccountId = az storage account create -l "northeu" -n $storageaccountName -g $resourcegroupName --output json --query "[id]"
        az storage container create --name "terraform" --account-name $storageaccountName
        write-host $storageaccountId

        # get storageaccountkey
        $storagekey = (Get-AzureRmStorageAccountKey -ResourceGroupname $resourcegroupName -AccountName $storageaccountName)[0].value
        az pipelines variable create --name "Storagekey" --value $storagekey --org $fullOrgName --pipeline-id $pipelineId
        
    }
    elseif($resourcegroupExists -eq "true" -or $repositoryExists -eq "true" -or $pipelineExists -eq "true" -or $storageaccountExists -eq "true")
    {
        read-host "Resourcegroup, pipeline, repository or storageaccount with name already exists, choose another resourcename"
    }
}

read-host "Enter to exit..."