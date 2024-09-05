# pre
write-host "OBS!!! READ BEFORE PROCEEDING" -ForegroundColor Red
write-host ""
write-host "Before proceeding, you must verify that you have the following:" -ForegroundColor Yellow
write-host " - A Microsoft Account or create a new one at:" -NoNewline -ForegroundColor Green
write-host " https://www.microsoft.com/" -ForegroundColor Cyan
write-host "   - Access to Azure DevOps at:" -NoNewline -ForegroundColor Green
write-host " https://dev.azure.com/" -ForegroundColor Cyan
write-host "   - An Organization in Azure DevOps or create a new one" -ForegroundColor Green
write-host "   - Access to Azure Cloud at:" -NoNewline -ForegroundColor Green
write-host " https://portal.azure.com/" -ForegroundColor Cyan
write-host "   - A Subscription in Azure Portal or create a new one, which subsequently creates associated resources:"-ForegroundColor Green
write-host "     - A Billing account"-ForegroundColor Green
write-host "     - A Billing profile"-ForegroundColor Green
write-host "     - An Invoice section"-ForegroundColor Green
write-host ""

while($verifySetup -ne "y" -and $verifySetup -ne "n")
{
    write-host "Have you verified the above? Otherwise the script will fail. (y/n)" -NoNewline -ForegroundColor Yellow
    $verifySetup = read-host
}

if($verifySetup -eq "y")
{
    cd $PWD.Path

    ################################################## run chooseorganization script ##################################################

        ## prompt to enter organisation name name
        #az login
        $orgExists = "false"
        while($orgExists -eq "false")
        {
            $orgName = read-host "What is the name your Azure DevOps organization?" # used to check project and repo name before accepting chosen projectname, and git init
            write-host $orgName"?"
            read-host "(y/n)"
            $fullOrgName = "https://dev.azure.com/"+$orgName+"/"
            $fullOrgName = $fullOrgName.Replace(" ","")
            write-host $fullOrgName

            # test if org exists v
            write-host "Checking if organization exists..."
            $statusCode = ""
            $statusCode = az devops project create --name lolsjgdhej --organization $fullOrgName --output tsv 2>$null
            #write-host "Statuscode: $statusCode 123"
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
            read-host "Enter to proceed..."
        }

        $tempProjectId = az devops project show --project lolsjgdhej --organization $fullOrgName --query "[id]" --output tsv 2>$null
        #write-host "Tempid: "$tempProjectId
        $tempProjectId = $tempProjectId.Replace("]","")
        $tempProjectId = $tempProjectId.Replace("[","")
        $tempProjectId = $tempProjectId.Replace(" ","")
        #write-host "Tempid: $tempProjectId"
        $statusCode = az devops project delete --id $tempProjectId --organization $fullOrgName -y --output tsv 2>$null
        #write-host "Statuscode: $statusCode 321"
        read-host "Enter to proceed..."
        # test if found exists ^

        # cd ..
        # cd ..
        # write-host $PWD.Path
        # Rename-Item -Path "$orgFolder" -NewName $orgName
        # cd $orgName
        # cd "starter-kit" # change to 'starter-kit' when done

        read-host "Enter to exit..."
        
        # $scriptpath = $PWD.Path + '\scripts\chooseorganization.ps1'
        # write-host $scriptpath
        # & $scriptpath run #-newRepoName $newRepoName run
        read-host "Enter to proceed..."


    ################################################## run createsubscription script ##################################################

        # remove these when done v
        #$projectName = "jgdtest"
        # remove these when done ^

        # check if azure subscription exists
        #$subName = $projectName+"subscription"
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
            #read-host "hmm"

            if($tempSubName -eq $subName -and $tempSubName -ne "")
            {
                $subExists = "true"
                
                $subId = az account show --name $subName --query "[id]" --output tsv 2>$null
                $subIdFormatted = "("+$subId+")"
                $fullSubId = $subName + " " + $subIdFormatted
                write-host "FullSubId: "$fullSubId

                # prompt if wanna use, else prompt subname with while loop if no
            }
            else
            {
                write-host "Can't find subscription"
                $subExists = "false"
            }

            #write-host $listOfsubs -erroraction 'silentlycontinue'
            write-host $subExists
            write-host "Done checking if subscription exists..."
        }

        read-host "Enter to proceed..."
        
        # $scriptpath = $PWD.Path + '\scripts\choosesubscription.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."


    ################################################## run chooseproject script ##################################################

        # # remove these when done v
        # $fullOrgName = "https://dev.azure.com/JonasDamsbo/"
        # # remove these when done ^

        #$fullOrgName = $args[0]

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
        
        # $scriptpath = $PWD.Path + '\scripts\chooseproject.ps1'
        # write-host $scriptpath
        # & $scriptpath "$fullOrgName" run #-newRepoName $newRepoName run
        # read-host "Enter to proceed..."


    ################################################## run chooseresources script ##################################################

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
            $repositoryName = "$resourceName"+"Repository"
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
        
        # $scriptpath = $PWD.Path + '\scripts\chooseresources.ps1'
        # write-host $scriptpath
        # & $scriptpath run #-newRepoName $newRepoName run
        # read-host "Enter to proceed..."


    # ################################################## run createrepo script ##################################################

        # $scriptpath = $PWD.Path + '\scripts\createrepo.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."


    ################################################## run replace pipeline-cloud-setup-repo script ##################################################

        # # ### Replace temp vars, uses projectname

        # # #New-Variable -Name "subscriptionName" -Visibility Public -Value ""
        # # #New-Variable -Name "subscriptionId" -Visibility Public -Value ""

        # # #$username = read-host "Type azure username" # "jonasdamsbo@hotmail.com"
        # # #$password = read-host "Type azure password" -AsSecureString # "Jones123!321hejlol"

        # # #Write-Host "Trying to login"
        # # #az login -u $username -p $password
        # # #az login # login with prompt, can outcomment username and password on line 4 and 5
        # # #Read-Host "Press enter to continue..."
        # # # LOGIN IN 'createrpo' and remove from here

        # # # Write-Host "Trying to get subid"
        # # # $subscriptionId = az account list --query "[?isDefault].id" --output tsv
        # # # $subidFormatted = "("+$subscriptionId+")"
        # # # $subscriptionName = az account list --query "[?isDefault].name" --output tsv
        # # # $fullSubId = $subscriptionName + " " + $subidFormatted
        # # # Write-Host $fullSubId
        # # # Read-Host "Press enter to continue..."

        # # # Write-Host "Trying to get webapp and apiapp ids"
        # # # $appservices = az webapp list --query "[?state=='Running'].name" --output tsv
        # # # $apiappname = $appservices[0]
        # # # $webappname = $appservices[1]
        # # # Write-Host $apiappname
        # # # Write-Host $webappname
        # # # Read-Host "Press enter to continue..."

        ### replace pipeline # replace temp vars in pipeline files with projectname -> fullsubid+webappname+apiappname
        write-host "Replacing vars in azure-pipelines.yml"
        # # # $subscriptionId = az account list --query "[?isDefault].id" --output tsv
        # # # $subidFormatted = "("+$subscriptionId+")"
        # # # $subscriptionName = az account list --query "[?isDefault].name" --output tsv
        # # # $fullSubId = $subscriptionName + " " + $subidFormatted

        # # # replace pipeline.yml vars fullsubid+webappname+apiappname
        # # # write-host "Trying to replace temp vars in yml pipeline file"
        # # # ((Get-Content -path azurepipeline.yml -Raw) -replace 'tempsubid',$fullSubId) | Set-Content -Path azurepipeline.yml
        # # # ((Get-Content -path azurepipeline.yml -Raw) -replace 'tempapiname',$apiappname) | Set-Content -Path azurepipeline.yml
        # # # ((Get-Content -path azurepipeline.yml -Raw) -replace 'tempwebname',$webappname) | Set-Content -Path azurepipeline.yml
        # # # Get-Content -path azurepipeline.yml
        cd "./.azure/"

        # replace tempsubid with $fullSubId
        ((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempsubscriptionid',$fullSubId) | Set-Content -Path azure-pipelines.yml

        ((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path azure-pipelines.yml
        ((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempstorageaccount',$storageaccountName) | Set-Content -Path azure-pipelines.yml

        # replace tempapiname with $apiappname
        $apiappname = $resourceName+"Apiapp"
        ((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempapiappname',$apiappname) | Set-Content -Path azure-pipelines.yml

        # replace tempwebname with $webappname
        $webappname = $resourceName+"Webapp"
        ((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempwebappname',$webappname) | Set-Content -Path azure-pipelines.yml

        cd ..

        Read-Host "Press enter to continue..."


        ### replace cloud # replace temp vars in terraform files in project/.terraform folder with projectname, + subscription&organization, + principalname?, 
        write-host "Replacing vars in *.tf"
        cd "./.terraform/"

        # replace temporganizationname with $fullOrgName in main.tf
        ((Get-Content -path main.tf -Raw) -replace 'temporganizationname',$fullOrgName) | Set-Content -Path main.tf

        # replace tempsubscriptionid with $fullSubId in main.tf
        ((Get-Content -path main.tf -Raw) -replace 'tempsubscriptionid',$fullSubId) | Set-Content -Path main.tf

        # replace tempprincipalname with $principalname in repositories.tf
        # $principalname = $resourceName
        # ((Get-Content -path repositories.tf -Raw) -replace 'tempprincipalname',$principalname) | Set-Content -Path repositories.tf

        # replace tempprojectname with $projectName in *.tf
        ((Get-Content -path main.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path main.tf
        ((Get-Content -path appservices.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path appservices.tf
        ((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path nosqldatabases.tf
        ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path sqldatabases.tf
        # ((Get-Content -path pipelines.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path pipelines.tf
        # ((Get-Content -path repositories.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path repositories.tf

            # replace repo, pipeline, resourcegroup, storageaccount... tempresourcename with $resourceName in *.tf
            ((Get-Content -path main.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path main.tf
            ((Get-Content -path appservices.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path appservices.tf
            ((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path nosqldatabases.tf
            ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path sqldatabases.tf

            ## replace tempids with $*id in main.tf

            #tempazuredevopsprojectid
            ((Get-Content -path main.tf -Raw) -replace 'tempazuredevopsprojectid',$projectid) | Set-Content -Path main.tf

            #tempazurerepositoryid
            ((Get-Content -path main.tf -Raw) -replace 'tempazurerepositoryid',$repositoryId) | Set-Content -Path main.tf

            #temppipelineid
            ((Get-Content -path main.tf -Raw) -replace 'temppipelineid',$pipelineId) | Set-Content -Path main.tf

            #tempresourcegroupid
            ((Get-Content -path main.tf -Raw) -replace 'tempresourcegroupid',$resourcegroupId) | Set-Content -Path main.tf

            #tempstorageaccountid and tempstoragekey
            ((Get-Content -path main.tf -Raw) -replace 'tempstorageaccountid',$storageaccountId) | Set-Content -Path main.tf
            ((Get-Content -path main.tf -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path main.tf


            ### replace apiurl and constrs, can be done in refreshcloudips.ps1
            # get and add apiurl for webapp
            $apiurl = $resourceName+"Apiapp.azurewebsites.net"
            $webappname = $resourcename+"Webapp"
            ((Get-Content -path appservices.tf -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path appservices.tf

            # get and add mongodb and mssqldb connectionstrings for apiapp
            $nosqlconnectionstring = "
            mongodb+srv://
            "+$resourceName+":
            'P4ssw0rd'
            @"+$resourceName+"cosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"

            $sqlconnectionstring = "
            Server=tcp:"+$resourceName+"sqldbserver.database.windows.net,1433;
            Initial Catalog="+$resourceName+"sqldb;
            Persist Security Info=False;
            User ID="+$resourceName+";Password=P@ssw0rd;
            MultipleActiveResultSets=False;
            Encrypt=True;
            TrustServerCertificate=False;
            Connection Timeout=30;
            "
            $apiappname = $resourcename+"Apiapp"
            ((Get-Content -path appservices.tf -Raw) -replace 'tempsqlconnectionstring',$sqlconnectionstring) | Set-Content -Path appservices.tf #
            ((Get-Content -path appservices.tf -Raw) -replace 'tempnosqlconnectionstring',$nosqlconnectionstring) | Set-Content -Path appservices.tf

        cd ..

        # # # Can you create subscription+billingaccount+billingprofile+invoicesection with terraform?
        # # # find billingaccount, billingprofile and invoicesection
        # # # az billing account list
        # # # az billing profile list --account-name 086682b6-a4b1-57e9-5bdd-62806d3dc3c0:b4ca7cb9-8c50-4b0c-9347-e7cbccca336f_2019-05-31
        # # # az billing invoice section list --account-name 086682b6-a4b1-57e9-5bdd-62806d3dc3c0:b4ca7cb9-8c50-4b0c-9347-e7cbccca336f_2019-05-31 --profile-name M3E4-IYP6-BG7-PGB
        # # # replace billingaccount, billingprofile and invoicesection in main.tf
        # # # az account create --enrollment-account-name --offer-type {MS-AZR-0017P, MS-AZR-0148P, MS-AZR-USGOV-0015P, MS-AZR-USGOV-0017P, MS-AZR-USGOV-0148P}

        Read-Host "Press enter to continue..."


        ### replace old-project # (tempprojectname with $projectName & temporganizationname with $orgName) in old-project script in new folder # azuregit etc?, 
        write-host "Replacing vars in old-project.ps1"
        cd "./scripts/"

        # replace tempprojectname with $projectName
        ((Get-Content -path old-project.ps1 -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path old-project.ps1

        # replace temporganizationname with $orgName
        ((Get-Content -path old-project.ps1 -Raw) -replace 'temporganizationname',$orgName) | Set-Content -Path old-project.ps1

        #replace resourcename in refreshcloudips.ps
        ((Get-Content -path refreshcloudips.ps1 -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path refreshcloudips.ps1

        cd ..


        ## Replacing branch-policy vars
        write-host "Replacing vars in branch-policy.json"
        cd "./.azure/"

        # replace tempprojectname with $projectName
        ((Get-Content -path branch-policy.json -Raw) -replace 'temprepositoryid',$repositoryId) | Set-Content -Path branch-policy.json

        cd ..

        # # # replace tempazureorgit with $azureorgit

        # # # replace azureOrg in testazurelogin.ps1
        # # # az login
        # # # az devops project list --detect true
        # # # az devops project list --org $azureorg

        # # # Read-Host "Press enter to continue..."

        # # # write-host "Trying to replace tempOrgName in testazurelogin.ps1 file"
        # # # ((Get-Content -path testazurelogin.ps1 -Raw) -replace 'tempOrgName',$azureOrg) | Set-Content -Path testazurelogin.ps1
        # # # Get-Content -path testazurelogin.ps1
        # # # Read-Host "Press enter to continue..."

        Read-Host "Press enter to continue..."
        
        # $scriptpath = $PWD.Path + '\scripts\replacefiles.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."


    # ################################################## run createpipeline script ##################################################

        # $scriptpath = $PWD.Path + '\scripts\createpipeline.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."


    # ################################################## run refreshcloudips script ##################################################

        # $scriptpath = $PWD.Path + '\scripts\refreshcloudips.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."


    ################################################## run pushtorepo script ##################################################

        # push repofolder to repo

        ### init git and push initial commit, create branches

        # init git repo
        git init
        write-host "init done"
        git remote add origin "https://"+"$orgName"+"@dev.azure.com/"+"$orgName$projectName"+"_git/"+"$projectName"
        write-host "remote add done"

        # push
        git add .
        git commit -m "initial commit"
        git push

        # create test and production branches
        git fetch
        git pull
        git branch "test"
        git branch "pre-production"
        git branch "production"
        git checkout "main"
        git push origin "test"
        git push origin "pre-production"
        git push origin "production"

        # push
        git add .
        git commit -m "created branches"
        git push

        # add master branch lock
        az repos policy create --config '\.azure\branch-policy.json'


        Read-Host "Press enter to continue..."
    
        # $scriptpath = $PWD.Path + '\scripts\pushtorepo.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."

    ################################################## before pipeline and tools-installer ##################################################

        write-host "Before running your pipeline:"
        write-host " - Go to your Azure DevOps project"
        write-host " - Project settings"
        write-host " - Pipelines > Service Connections"
        write-host " - New service connection"
        write-host " - Azure Resource Manager"
        write-host " - Service Principal (automatic)"
        write-host " - Select subscription"
        write-host " - Leave resource group blank"
        write-host " - Write 'Azure Resource Manager' in service connection name"
        write-host " - Check 'Grant access permissions to all pipelines' under security"
        write-host
        read-host "Press enter when done..."

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
        read-host "Enter to proceed..."
}
read-host "Enter to exit..."