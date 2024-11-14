# pre
write-host "OBS!!! READ BEFORE PROCEEDING" -ForegroundColor Red
write-host ""
write-host "Before proceeding, you must verify that you have the following:" -ForegroundColor Yellow
write-host " - A Microsoft Account or create a new one at:" -NoNewline -ForegroundColor Green
write-host " https://www.microsoft.com/" -ForegroundColor Cyan
write-host "   - Access to Azure DevOps at:" -NoNewline -ForegroundColor Green
write-host " https://dev.azure.com/" -ForegroundColor Cyan
write-host "   - An Organization in Azure DevOps or create a new one" -ForegroundColor Green
write-host "   - Permission for your organization to use parallelism at:" -NoNewline -ForegroundColor Green
write-host " https://aka.ms/azpipelines-parallelism-request" -ForegroundColor Cyan
write-host "   - Access to Azure Cloud at:" -NoNewline -ForegroundColor Green
write-host " https://portal.azure.com/" -ForegroundColor Cyan
write-host "   - A Subscription in Azure Portal or create a new one, which subsequently creates associated resources:"-ForegroundColor Green
write-host "     - A Billing account"-ForegroundColor Green
write-host "     - A Billing profile"-ForegroundColor Green
write-host "     - An Invoice section"-ForegroundColor Green
write-host "   - Go to your Subscription > Resource providers > Search for Microsoft.Storage > Select and register"
write-host ""

while($verifySetup -ne "y" -and $verifySetup -ne "n")
{
    write-host "Have you verified the above? Otherwise the script will fail. (y/n)" -NoNewline -ForegroundColor Yellow
    $verifySetup = read-host
}

if($verifySetup -eq "y")
{
    Set-Location $PWD.Path

    ################################################## run chooseorganization script ##################################################

        ## prompt to enter organisation name name
        az login
        $orgExists = "false"
        while($orgExists -eq "false")
        {
	    $pat = read-host "Please enter Azure DevOps org PAT key (Create in settings > Personal Access Tokens)"
	    $env:AZURE_DEVOPS_EXT_PAT = $pat

            $orgName = read-host "What is the name your Azure DevOps organization?" # used to check project and repo name before accepting chosen projectname, and git init
            $fullOrgName = "https://dev.azure.com/"+$orgName+"/"
            $fullOrgName = $fullOrgName.Replace(" ","")
            write-host $fullOrgName

            # test if org exists v
            write-host "Checking if organization exists..."
            $statusCode = ""
            $statusCode = az devops project create --name lolsjgdhej --organization $fullOrgName --output tsv 2>$null
            if($statusCode.Length -lt 1)
            {
                write-host "organization does not exist..."
            }
            else
            {
                $orgExists = "true"
                write-host "organization exists..."
            }
            
            write-host "Done checking if organization exists..."
        }

        $tempProjectId = az devops project show --project lolsjgdhej --organization $fullOrgName --query "[id]" --output tsv 2>$null
        $tempProjectId = $tempProjectId.Replace("]","")
        $tempProjectId = $tempProjectId.Replace("[","")
        $tempProjectId = $tempProjectId.Replace(" ","")
        $statusCode = az devops project delete --id $tempProjectId --organization $fullOrgName -y --output tsv 2>$null
        read-host "Enter to proceed..."


    ################################################## run createsubscription script ##################################################

        $subName = ""
        $subId = ""
        $fullSubId = ""
        $subExists = "false"
        write-host "Subname: "$subName

        while($subExists -ne "true")
        {
            $subName = read-host "What is the name your Azure Subscription?"
            write-host "Checking if subscription exists..."
            $tempSubName = az account show --name $subName --query "[name]" --output tsv 2>$null
            write-host "AzSub: "$tempSubName

            if($tempSubName -eq $subName -and $tempSubName -ne "")
            {
                $subExists = "true"
                
                $subId = az account show --name $subName --query "[id]" --output tsv 2>$null
                $subIdFormatted = "("+$subId+")"
                $fullSubId = $subName + " " + $subIdFormatted
                write-host "FullSubId: "$fullSubId
            }
            else
            {
                write-host "Can't find subscription"
                $subExists = "false"
            }

            write-host $subExists
            write-host "Done checking if subscription exists..."
        }

        read-host "Enter to proceed..."


    ################################################## run chooseproject script ##################################################

        $projectName = ""
        $projectExists = "false"
        $firstRun = "true"
        $bypass = "false"

        ## prompt desired repo/project name
        while((($projectExists -eq "true") -or $firstRun -eq "true") -and $bypass -ne "true")
        {
            $firstRun = "false"
            $projectName = read-host "What do you want to name your new project?"

            ## check if project with name already exists
            write-host "Checking if project exists..."
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

            write-host $listOfProjects -erroraction 'silentlycontinue'
            write-host $projectExists

            # create project
            if($projectExists -eq "false")
            {
                write-host "fullorgname: "$fullOrgName
                $statusProj = az devops project create --name $projectName --organization $fullOrgName --output tsv 2>$null
                write-host $statusProj
                $projectId = az devops project show --project $projectName --org $fullOrgName --query "[id]" --output tsv 2>$null
                write-host $projectId
                
                write-host "Project name can be used"
            }
            elseif($projectExists -eq "true")
            {
                while($useExisting -ne "y" -and $useExisting -ne "n")
                {
                    #use existing?
                    $useExisting = read-host "Project already exists, use existing project? (y/n)"
                    if($useExisting -eq "y")
                    {
                        $projectId = az devops project show --project $projectName --org $fullOrgName --query "[id]" --output tsv 2>$null
                        write-host $projectId
                        $bypass = "true"
                    }
                }
                $useExisting = ""
            }

            write-host "Done checking if project..."
        }

        read-host "Enter to proceed..."


    ################################################## run chooseresources script ##################################################

        ## repeat loop if any resource with the desired name already exists
        $resourcegroupExists = "true"
        while($resourcegroupExists -eq "true" -or $repositoryExists -eq "true" -or $pipelineExists -eq "true" -or $storageaccountExists -eq "true")
        {

        ## choose resource name
            write-host "What would you like to call your resources?"
            write-host "   - repository, pipeline, resourcegroup, webapp, api, databases, storageaccount"
            write-host "   - ex: if you enter 'myresources', the repository will be named myresourcesRepository"
            $resourceName = read-host

        ## check if resourcegroup exists
            write-host "Checking if resourcegroup exists..."
            $resourcegroupName = $resourceName+"resourcegroup"
            $resourcegroupExists = "false"
            $listOfResourcegroups = az group show --name $resourcegroupName --query "[name]" --output tsv 2>$null

            if($listOfResourcegroups -eq $resourcegroupName)
            {
                $resourcegroupExists = "true"
            }
            else
            {
                $resourcegroupExists = "false"
            }

            write-host "Done checking if resourcegroup exists..."
            write-host

        ## check if storageaccount exists
            write-host "Checking if storageaccount exists..."
            $storageaccountName = $resourceName+"storageaccount"
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

            write-host "Done checking if storageaccount exists..."
            write-host

        ## check if repository exists
            write-host "Checking if repository exists..."
            $repositoryName = "$resourceName"+"repository"
            write-host "reponame: "$repositoryName
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

        ## check if pipeline exists
            write-host "Checking if pipeline exists..."
            $pipelineName = $resourceName+"pipeline"
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

        ## create resources if resource names dont already exist, else retry
            if($resourcegroupExists -eq "false" -and $repositoryExists -eq "false" -and $pipelineExists -eq "false" -and $storageaccountExists -eq "false")
            {
                $resourcesDontExist = "true"
            }
            elseif($resourcegroupExists -eq "true" -or $repositoryExists -eq "true" -or $pipelineExists -eq "true" -or $storageaccountExists -eq "true")
            {
                read-host "Resourcegroup, pipeline, repository or storageaccount with name already exists, choose another resourcename"
            }
        }

        read-host "Done checking preliminary resources, press enter to proceed..."

    
    # ########################################### register enterprise app and get tenantid, clientid and clientsecret #########################################

        write-host "Getting and replacing tenantid, clientid, clientsecret..."
        
        $subscriptionId = $subId

        $applicationName = $resourceName+"appregistration"
        $appDetailsJson = az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$subscriptionId" --name $applicationName
        write-host "appdetailsjson: $appDetailsJson"
        $appDetails = $appDetailsJson | ConvertFrom-Json
        write-host "appdetails: $appDetails"

        $clientid = $appDetails.appId
        write-host "clientid: $clientid"

        $clientsecret = $appDetails.password
        write-host "clientsecret: $clientsecret"

        $tenantid = $appDetails.tenant
        write-host "tenantid: $tenantid"

        read-host "Done getting and replacing tenantid, clientid, clientsecret... press enter to continue"
        

    # ################################################## run create preliminary resources script #################################################

        if($resourcesDontExist -eq "true")
        {
            # create resources
            write-host "Creating preliminary resources..."
            write-host "path: "$PWD.Path

            # create repo - 
            $repositoryId = az repos create --name $repositoryName --org $fullOrgName --project $projectName --output json --query "[id]"
            $repositoryId = $repositoryId.Replace("[","")
            $repositoryId = $repositoryId.Replace("]","")
            $repositoryId = $repositoryId.Replace(" ","")
            write-host $repositoryId
            write-host "Done creating repository..."

            write-host "Deleting old repository..."
            $oldRepoId = az repos show --repository $projectName --org $fullOrgName --project $projectName --output json --query "[id]"
            $oldRepoId = $oldRepoId.Replace("[","")
            $oldRepoId = $oldRepoId.Replace("]","")
            $oldRepoId = $oldRepoId.Replace(" ","")
            write-host "Oldrepo id: "+$oldRepoId
            az repos delete --id $oldRepoId --org $fullOrgName --project $projectName --yes
            write-host "Done deleting old repository..."

            # create resourcegroup
            $resourcegroupId = az group create -l "northeurope" -n $resourcegroupName --managed-by $fullSubId --output json --query "[id]"
            write-host $resourcegroupId
            write-host "Done creating resourcegroup..."

            # create storageaccount and container
            write-host "Started creating storageaccount..."
            $storageaccountId = az storage account create -l "northeurope" -n $storageaccountName -g $resourcegroupName --sku Standard_LRS --output json --query "[id]"
            write-host "Done creating storageaccount..."

            write-host "Started creating storageaccount container..."
            $terraformcontainername = "terraform"
            az storage container create --name $terraformcontainername --account-name $storageaccountName
            write-host $storageaccountId
            write-host "Done creating storageaccount container..."

            # get storageaccountkey
            write-host "Started getting storage key..."
            $storagekey = az storage account keys list -g $resourcegroupName -n $storageaccountName --query "[0].value"
            $storageconnectionstring = az storage account show-connection-string --resource-group $resourcegroupName --name $storageaccountName --output tsv
            write-host "Done creating pipeline variable from storage key..."
        }

        read-host "Done creating preliminary resources... press enter to continue"


    ################################################## prepare cloud vars ######################################################

        $weburl = "https://"+$resourceName+"webapp.azurewebsites.net/"
        $sqlpassword = -join (((48..57) | Get-Random | % {[char]$_})+((65..90) | Get-Random | % {[char]$_})+((97..122) | Get-Random | % {[char]$_})+(-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 10 | % {[char]$_})))

        $variableGroupName = $resourceName+"variablegroup"


    # ############################################# replace vars in old-project.ps1 ############################################
        
        write-host "Replacing vars in old-project.ps1"
                
        Set-Location "./scripts/"

        ((Get-Content -path old-project.ps1 -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path old-project.ps1
        ((Get-Content -path old-project.ps1 -Raw) -replace 'temporganizationname',$orgName) | Set-Content -Path old-project.ps1
        ((Get-Content -path old-project.ps1 -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path old-project.ps1

        Set-Location ..

        read-host "Done replacing vars in old-project.ps1, press enter to proceed..."

    
    # ############################################# replace vars in setcloudvars.ps1 ############################################
        
        write-host "Replacing vars in setcloudvars.ps1"
                    
        Set-Location "./scripts/"

        ((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path setcloudvars.ps1

        Set-Location ..

        read-host "Done replacing vars in setcloudvars.ps1, press enter to proceed..."


    ################################################## replace vars in .tf files ##################################################

        write-host "Replacing vars in .tf files"

        Set-Location "./terraform/"

        # replace x with $x in main.tf
            ((Get-Content -path main.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path main.tf
            ((Get-Content -path main.tf -Raw) -replace 'tempterraformcontainername',$terraformcontainername) | Set-Content -Path main.tf
            ((Get-Content -path main.tf -Raw) -replace 'temporganizationname',$orgName) | Set-Content -Path main.tf

        # replace x with $x in appservices.tf
            ((Get-Content -path appservices.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path appservices.tf

        # replace x with $x in sqldatabases.tf
            ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path sqldatabases.tf

        Set-Location ..

        read-host "Done replacing vars in .tf files, press enter to proceed..."

    # ################################################## replace vars in README.md #################################################

        write-host "Replacing vars in readme.txt" # put alt i readme som ikke sættes i lib vars

        ((Get-Content -path README.md -Raw) -replace 'temporganizationname',$orgName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempsubscriptionname',$subName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempresourcegroupname',$resourcegroupName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'temprepositoryname',$repositoryName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'temppipelinename',$pipelineName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempvariablegroupname',$variableGroupName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempapplicationname',$applicationName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempwebappurl',$weburl) | Set-Content -Path README.md

        read-host "Done replacing vars in readme.txt, press enter to proceed..."


    ################################################## run pushtorepo script ##################################################

        write-host "Before running your pipeline:"
        write-host " - Go to your Azure DevOps project"
        write-host " - Project settings"
        write-host " - Pipelines > Service Connections"
        write-host " - New service connection"
        write-host " - Azure Resource Manager"
        write-host " - App registration (automatic)"
        write-host " - Select subscription"
        write-host " - Leave resource group blank"
        write-host " - Write 'Azure Resource Manager' in service connection name"
        write-host " - Check 'Grant access permissions to all pipelines' under security"
        write-host
        read-host "Press enter when done..."
        write-host 

        # push repofolder to repo
        ### init git and push initial commit, create branches

        write-host "Configuring and pushing to git repository..."

        # init git repo
            git init
            write-host "init done"
            $remotename = "https://"+"$orgName"+"@dev.azure.com/"+"$orgName"+"/"+"$projectName"+"/_git/"+"$repositoryName"
            write-host "remotename: "$remotename
            git remote add $repositoryName $remotename
            write-host "remote add done"

        # push
            git add .
            git commit -m "initial commit"
            git push --set-upstream $repositoryName master
            git push $repositoryName

        # add master branch lock
            write-host
            write-host $PWD.Path
            write-host "Creating no push to master policy"
            az repos policy approver-count create --allow-downvotes true --blocking true --branch master --creator-vote-counts false --enabled true --minimum-approver-count 1 --repository-id $repositoryId --org $fullOrgName --project $projectName --reset-on-source-push false

        Read-Host "Done configuring and pushing to git repository... press enter to continue"

    ################################################## create library variable group ##################################################
        
        write-host "Started creating library variablegroup..."

        $variableGroupId = az pipelines variable-group create --name $variableGroupName --organization $fullOrgName --project $projectName --authorize --variables "subscriptionid=$subId" --output json --query "[id]"
        $variableGroupId = $variableGroupId.Replace("[","")
        $variableGroupId = $variableGroupId.Replace("]","")
        $variableGroupId = $variableGroupId.Replace(" ","")

        write-host "variableGroupId: "$variableGroupId

        read-host "Done creating library variable group... press enter to continue"

    
    ################################################## new create sensitive library variable group variables ##################################################

        write-host "Started creating library variablegroup variables..."

        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "tenantid" --value $tenantid # sensitive?
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "clientid" --value $clientid # sensitive?
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "clientsecret" --value $clientsecret # sensitive
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "storagekey" --value $storagekey # sensitive
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "storageconnectionstring" --value $storageconnectionstring # sensitive
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "sqlpassword" --value $sqlpassword # sensitive

        #for azureservice
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "subscriptionname" --value $subName
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "organizationname" --value $orgName
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "fullorganizationname" --value $fullOrgName

        read-host "Done creating library variable group variables... press enter to continue"
            

    ################################################## create pipeline ##################################################
        # CREATE PIPELINE HERE
        write-host "Started creating pipeline..."

            $pipelineDeployName = "Deploy "+$resourceName
            az pipelines create --name $pipelineDeployName --yml-path '\azure\azure-pipelines.yml' --org $fullOrgName --project $projectName --repository-type "tfsgit" --repository $repositoryName --branch "master"

            $pipelineId = az pipelines show --name $pipelineDeployName --org $fullOrgName --project $projectName --output json --query "[id]"
            $pipelineId = $pipelineId.Replace("[","")
            $pipelineId = $pipelineId.Replace("]","")
            $pipelineId = $pipelineId.Replace(" ","")
            write-host "PipelineId: "$pipelineId
            $pipelines = az pipelines list --org $fullOrgName --project $projectName --output json
            write-host "Pipelines: "$pipelines
                
        Read-Host "Done creating pipeline... press enter to continue"


    ################################################## prompt set up release in azure devops ##################################################
        write-host 
        write-host "Finally, you need to setup your release in Azure DevOps (See the development guide for help, link in readme.md):"
        write-host " - Go to your Azure DevOps project"
        write-host " - Pipelines > Releases > +New v > New release pipeline"
        write-host " - Template > Select empty job > setup 2 stages:"
        write-host " - - Stage 1: setup 7 tasks"
        write-host " - - - Task 1: Setup a Replace tokens Azure CLI ps1 script task"
        write-host " - - - Task 2-6: Setup Terraform install/init/plan/validate/apply tasks"
        write-host " - - - Task 7: Setup a Set cloud ips Azure CLI ps1 script task"
        write-host " - - Stage 2: setup 2 tasks"
        write-host " - - - Step 1: Setup a Deploy webapp Azure App Service deploy task"
        write-host " - - - - write "+$resourceName+"webapp in app service name"
        write-host " - - - Step 2: Setup a Deploy apiapp Azure App Service deploy task"
        write-host " - - - - write "+$resourceName+"apiapp in app service name"
        write-host " - Go to Variables > Variable groups > Link variable group"
        write-host 
        write-host "For AzureService:"
        write-host " - Go to User settings > Personal access tokens > New token > Name it PAT and customize settings or choose full access > Create > Copy the PAT"
        write-host " - Go to Pipelines > Library > Variable groups > Pick your new variable group > Create new variable called PAT with value of your PAT"
        write-host 
        read-host "Press enter when done..."
        write-host 

    ################################################## before pipeline and tools-installer ##################################################

        write-host "Your project is set up!"

        # run install tools script
        while($installTools -ne "yes" -and $installTools -ne "no")
        {
            $userAnswer = read-host "Install developer tools? (yes/no)"
            if($userAnswer -eq "yes")
            {
                $installTools = "yes"
                $scriptpath = $PWD.Path + '\scripts\tools-installer.ps1'
                write-host $scriptpath
                write-host 
                & $scriptpath run
            }
        }
        #read-host "Enter to proceed..."
}
read-host "Enter to exit..."