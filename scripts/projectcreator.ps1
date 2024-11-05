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
            $orgName = read-host "What is the name your Azure DevOps organization?" # used to check project and repo name before accepting chosen projectname, and git init
            #write-host $orgName"?"
            #read-host "(y/n)"
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
            #read-host "Enter to proceed..."
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
        #write-host 
        # test if found exists ^

        # cd ..
        # cd ..
        # write-host $PWD.Path
        # Rename-Item -Path "$orgFolder" -NewName $orgName
        # cd $orgName
        # cd "starter-kit" # change to 'starter-kit' when done

        #read-host "Enter to exit..."
        
        # $scriptpath = $PWD.Path + '\scripts\chooseorganization.ps1'
        # write-host $scriptpath
        # & $scriptpath run #-newRepoName $newRepoName run
        #read-host "Enter to proceed..."


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
        #while((($projectExists -eq "true" -or $resourcegroupExists -eq "true") -or $firstRun -eq "true") -and $bypass -ne "true")
        while((($projectExists -eq "true") -or $firstRun -eq "true") -and $bypass -ne "true")
        {
            $firstRun = "false"
            $projectName = read-host "What do you want to name your new project?"
            #write-host $projectName"?"
            #read-host "(y/n)"
            #write-host $fullOrgName$projectName"/"

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
            #read-host

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

        read-host "Enter to proceed..."



        ######## INSERT Project service provider prompt here ########
        ######## INSERT Project service provider prompt here ########
        ######## INSERT Project service provider prompt here ########


        
        # $scriptpath = $PWD.Path + '\scripts\chooseproject.ps1'
        # write-host $scriptpath
        # & $scriptpath "$fullOrgName" run #-newRepoName $newRepoName run
        # read-host "Enter to proceed..."


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
                #$storageaccountExists = "false"
            }

            write-host "Done checking if resourcegroup exists..."
            write-host

        ## check if storageaccount exists
            # if($resourcegroupExists)
            # {
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
            # }

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
        
        # $scriptpath = $PWD.Path + '\scripts\chooseresources.ps1'
        # write-host $scriptpath
        # & $scriptpath run #-newRepoName $newRepoName run
        # read-host "Enter to proceed..."


    # ################################################## run createrepo script ##################################################

        # $scriptpath = $PWD.Path + '\scripts\createrepo.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."

    
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
        

    ################################################## run replace tokens pipeline-cloud-setup-repo script ##################################################

        # replace tempclientid with $clientid in main.tf
        #((Get-Content -path main.tf -Raw) -replace 'tempclientid',$clientid) | Set-Content -Path main.tf

        # replace tempclientsecret with $clientsecret in main.tf
        #((Get-Content -path main.tf -Raw) -replace 'tempclientsecret',$clientsecret) | Set-Content -Path main.tf

        # replace temptenantid with $tenantid in main.tf
        #((Get-Content -path main.tf -Raw) -replace 'temptenantid',$tenantid) | Set-Content -Path main.tf

        # replace tempenterpriseapplicationname with $applicationName in readme.md
        #((Get-Content -path readme.md -Raw) -replace 'tempenterpriseapplicationname',$applicationName) | Set-Content -Path readme.md

        #read-host "clientid, clientsecret, tenantid replace... continue?"


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
        #write-host "Replacing vars in azure-pipelines.yml"
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
        #cd "./.azure/"

        # replace tempsubid with $fullSubId
        #((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempsubscriptionid',$fullSubId) | Set-Content -Path azure-pipelines.yml

        #((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path azure-pipelines.yml
        #((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempstorageaccount',$storageaccountName) | Set-Content -Path azure-pipelines.yml

        # replace tempapiname with $apiappname
        #$apiappname = $resourceName+"apiapp"
        #((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempapiappname',$apiappname) | Set-Content -Path azure-pipelines.yml

        # replace tempwebname with $webappname
        # $webappname = $resourceName+"webapp"
        #((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempwebappname',$webappname) | Set-Content -Path azure-pipelines.yml

        #cd ..


        ### replace cloud # replace temp vars in terraform files in project/.terraform folder with projectname, + subscription&organization, + principalname?, 
        #write-host "Replacing vars in *.tf"
        #cd "./.terraform/"

        # replace temporganizationname with $fullOrgName in main.tf
        #((Get-Content -path main.tf -Raw) -replace 'temporganizationname',$fullOrgName) | Set-Content -Path main.tf

        # replace tempsubscriptionid with $fullSubId in main.tf
        #((Get-Content -path main.tf -Raw) -replace 'tempsubscriptionid',$subId) | Set-Content -Path main.tf

        # replace tempprincipalname with $principalname in repositories.tf
        # $principalname = $resourceName
        # ((Get-Content -path repositories.tf -Raw) -replace 'tempprincipalname',$principalname) | Set-Content -Path repositories.tf

        # replace tempprojectname with $projectName in *.tf
        # ((Get-Content -path main.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path main.tf
        # ((Get-Content -path appservices.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path appservices.tf
        # ((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path nosqldatabases.tf
        # ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path sqldatabases.tf
        # ((Get-Content -path pipelines.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path pipelines.tf
        # ((Get-Content -path repositories.tf -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path repositories.tf

            # replace repo, pipeline, resourcegroup, storageaccount... tempresourcename with $resourceName in *.tf
            # ((Get-Content -path main.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path main.tf
            # ((Get-Content -path appservices.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path appservices.tf
            # ((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path nosqldatabases.tf
            # ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path sqldatabases.tf

            ## replace tempids with $*id in main.tf

            ### replace apiurl and constrs, can be done in setcloudvars.ps1
            # get and add apiurl for webapp
            #$apiurl = "https://"+$resourceName+"apiapp.azurewebsites.net/"
            #$webappname = $resourceName+"webapp"
            #$appserviceplanname = $resourceName+"appserviceplan"
            #((Get-Content -path appservices.tf -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path appservices.tf

            # get and add mongodb and mssqldb connectionstrings for apiapp
            #$nosqlconnectionstring = "mongodb+srv://sa:'P%40ssw0rd'@"+$resourceName+"cosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"
            #$cosmosmongodbname = $resourceName+"cosmosmongodb"
            #$cosmosdbaccountname = $resourceName+"cosmosdbaccount"

            #$sqlconnectionstring = "Server=tcp:"+$resourceName+"mssqlserver.database.windows.net,1433;Initial Catalog="+$resourceName+"mssqldatabase;Persist Security Info=False;User ID="+$resourceName+";Password=P@ssw0rd;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
            #$mssqldatabasename = $resourceName+"mssqldatabase"
            #$mssqlservername = $resourceName+"mssqlserver"
            #$apiappname = $resourceName+"apiapp"
            #((Get-Content -path appservices.tf -Raw) -replace 'tempsqlconnectionstring',$sqlconnectionstring) | Set-Content -Path appservices.tf
            #((Get-Content -path appservices.tf -Raw) -replace 'tempnosqlconnectionstring',$nosqlconnectionstring) | Set-Content -Path appservices.tf

        #cd ..

        # # # Can you create subscription+billingaccount+billingprofile+invoicesection with terraform?
        # # # find billingaccount, billingprofile and invoicesection
        # # # az billing account list
        # # # az billing profile list --account-name 086682b6-a4b1-57e9-5bdd-62806d3dc3c0:b4ca7cb9-8c50-4b0c-9347-e7cbccca336f_2019-05-31
        # # # az billing invoice section list --account-name 086682b6-a4b1-57e9-5bdd-62806d3dc3c0:b4ca7cb9-8c50-4b0c-9347-e7cbccca336f_2019-05-31 --profile-name M3E4-IYP6-BG7-PGB
        # # # replace billingaccount, billingprofile and invoicesection in main.tf
        # # # az account create --enrollment-account-name --offer-type {MS-AZR-0017P, MS-AZR-0148P, MS-AZR-USGOV-0015P, MS-AZR-USGOV-0017P, MS-AZR-USGOV-0148P}

    
    ### replace old-project # (tempprojectname with $projectName & temporganizationname with $orgName) in old-project script in new folder # azuregit etc?, 

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

        #replace org, proj, repo, pipeline, subscription, resouregroup, storageaccount in readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'temporganizationname',$orgName) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'temprepositoryname',$repositoryName) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'temppipelinename',$pipelineName) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempsubscriptionname',$subscriptionName) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempresourcegroupname',$resourcegroupName) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempstorageaccountname',$storageaccountName) | Set-Content -Path readme.txt
        
        # $scriptpath = $PWD.Path + '\scripts\replacefiles.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."


    # ################################################## run create preliminary resources script #################################################

        if($resourcesDontExist -eq "true")
        {
            # create resources
            write-host "Creating preliminary resources..."
            write-host "path: "$PWD.Path

            # create repo - 
            #$repoDetails = az repos create --name $repositoryName --org $fullOrgName --output json
            #write-host $repoDetails
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
            #$rgDetails = az group create -l "northeurope" -n $resourcegroupName
            $resourcegroupId = az group create -l "northeurope" -n $resourcegroupName --managed-by $fullSubId --output json --query "[id]"
            write-host $resourcegroupId
            write-host "Done creating resourcegroup..."

            # create storageaccount and container
            #$saDetails = az storage account create -l "northeurope" -n $storageaccountName -g $resourcegroupName
            write-host "Started creating storageaccount..."
            #Connect-AzAccount
            $storageaccountId = az storage account create -l "northeurope" -n $storageaccountName -g $resourcegroupName --sku Standard_LRS --output json --query "[id]"
            write-host "Done creating storageaccount..."

            write-host "Started creating storageaccount container..."
            $dbbackupcontainername = "dbbackup"
            $terraformcontainername = "terraform"
            az storage container create --name $terraformcontainername --account-name $storageaccountName
            az storage container create --name $dbbackupcontainername --account-name $storageaccountName
            write-host $storageaccountId
            write-host "Done creating storageaccount container..."

            # get storageaccountkey
            write-host "Started getting storage key..."
            $storagekey = az storage account keys list -g $resourcegroupName -n $storageaccountName --query "[0].value"
            #az pipelines variable create --name "Storagekey" --value $storagekey --org $fullOrgName --project $projectName --pipeline-id $pipelineId
            write-host "Done creating pipeline variable from storage key..."
        }

        read-host "Done creating preliminary resources... press enter to continue"


    ################################################## prepare cloud vars ######################################################

    
        #$apiurl = "https://"+$resourceName+"apiapp.azurewebsites.net/"
        # $apiappname = $resourceName+"apiapp"
        # $webappname = $resourceName+"webapp"
        # $appserviceplanname = $resourceName+"appserviceplan"

        $nosqlpassword = "P%40ssw0rd"
        # $nosqlconnectionstring = "mongodb+srv://sa:'"+$nosqlpassword+"'@"+$resourceName+"cosmosmongodb.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"
        # $cosmosmongodbname = $resourceName+"cosmosmongodb"
        # $cosmosdbaccountname = $resourceName+"cosmosdbaccount"

        $sqlpassword = "P@ssw0rd"
        # $sqlconnectionstring = "Server=tcp:"+$resourceName+"mssqlserver.database.windows.net,1433;Initial Catalog="+$resourceName+"mssqldatabase;Persist Security Info=False;User ID="+$resourceName+";Password="+$sqlpassword+";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
        # $mssqldatabasename = $resourceName+"mssqldatabase"
        # $mssqlservername = $resourceName+"mssqlserver"

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


    ################################################## replace vars in .yml files ###############################################

        write-host "Replacing vars in azure-pipelines-destroy.yml"

        Set-Location "./azure/"

        ((Get-Content -path azure-pipelines-destroy.yml -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path azure-pipelines-destroy.yml
        ((Get-Content -path azure-pipelines-destroy.yml -Raw) -replace 'tempstorageaccountname',$storageaccountName) | Set-Content -Path azure-pipelines-destroy.yml
        ((Get-Content -path azure-pipelines-destroy.yml -Raw) -replace 'tempterraformcontainername',$terraformcontainername) | Set-Content -Path azure-pipelines-destroy.yml

        Set-Location ..

        read-host "Done replacing vars in azure-pipelines-destroy.yml, press enter to proceed..."

    ################################################## replace vars in .tf files ##################################################

        write-host "Replacing vars in .tf files"

        Set-Location "./terraform/"

        # replace x with $x in main.tf
            ((Get-Content -path main.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path main.tf
            ((Get-Content -path main.tf -Raw) -replace 'tempterraformcontainername',$terraformcontainername) | Set-Content -Path main.tf
            ((Get-Content -path main.tf -Raw) -replace 'temporganizationname',$orgName) | Set-Content -Path main.tf

        # replace x with $x in appservices.tf
            ((Get-Content -path appservices.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path appservices.tf
            ((Get-Content -path appservices.tf -Raw) -replace 'tempdbbackupcontainername',$dbbackupcontainername) | Set-Content -Path appservices.tf
            #((Get-Content -path appservices.tf -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path appservices.tf

        # replace x with $x in nosqldatabases.tf
            ((Get-Content -path nosqldatabases.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path nosqldatabases.tf

        # replace x with $x in sqldatabases.tf
            ((Get-Content -path sqldatabases.tf -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path sqldatabases.tf

        Set-Location ..

        read-host "Done replacing vars in .tf files, press enter to proceed..."

    # ################################################## replace vars in README.md #################################################

        write-host "Replacing vars in readme.txt" # put alt i readme som ikke sættes i lib vars

        ((Get-Content -path README.md -Raw) -replace 'temporganizationname',$orgName) | Set-Content -Path README.md
        #((Get-Content -path readme.txt -Raw) -replace 'tempfullorganizationname',$fullOrgName) | Set-Content -Path readme.txt
        ((Get-Content -path README.md -Raw) -replace 'tempsubscriptionname',$subName) | Set-Content -Path README.md
        #((Get-Content -path readme.txt -Raw) -replace 'tempfullsubscriptionid',$fullSubId) | Set-Content -Path readme.txt
        ((Get-Content -path README.md -Raw) -replace 'tempprojectname',$projectName) | Set-Content -Path README.md
        #((Get-Content -path readme.txt -Raw) -replace 'tempprojectid',$projectId) | Set-Content -Path readme.txt
        #((Get-Content -path readme.txt -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path readme.txt
        ((Get-Content -path README.md -Raw) -replace 'tempresourcegroupname',$resourcegroupName) | Set-Content -Path README.md
        #((Get-Content -path readme.txt -Raw) -replace 'tempresourcegroupid',$resourcegroupId) | Set-Content -Path readme.txt
        ((Get-Content -path README.md -Raw) -replace 'temprepositoryname',$repositoryName) | Set-Content -Path README.md
        #((Get-Content -path readme.txt -Raw) -replace 'temprepositoryid',$repositoryId) | Set-Content -Path readme.txt
        ((Get-Content -path README.md -Raw) -replace 'temppipelinename',$pipelineName) | Set-Content -Path README.md
        #((Get-Content -path readme.txt -Raw) -replace 'temppipelineid',$pipelineId) | Set-Content -Path readme.txt
        ((Get-Content -path README.md -Raw) -replace 'tempvariablegroupname',$variableGroupName) | Set-Content -Path README.md
        #((Get-Content -path readme.txt -Raw) -replace 'tempvariablegroupid',$variableGroupId) | Set-Content -Path readme.txt
        
        ((Get-Content -path README.md -Raw) -replace 'tempapplicationname',$applicationName) | Set-Content -Path README.md

        ((Get-Content -path README.md -Raw) -replace 'tempstorageaccountname',$storageaccountName) | Set-Content -Path README.md
        #((Get-Content -path readme.txt -Raw) -replace 'tempstorageaccountid',$storageaccountId) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempterraformcontainername',$terraformcontainername) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempdbbackupcontainername',$dbbackupcontainername) | Set-Content -Path readme.txt
        
        # ((Get-Content -path readme.txt -Raw) -replace 'tempappserviceplanname',$appserviceplanname) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempwebappname',$webappname) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempapiappname',$apiappname) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempmssqlservername',$mssqlservername) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempmssqldatabasename',$mssqldatabasename) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempcosmosdbaccountname',$cosmosdbaccountname) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempcosmosmongodbname',$cosmosmongodbname) | Set-Content -Path readme.txt

        # ((Get-Content -path readme.txt -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempsqlconnectionstring',$sqlconnectionstring) | Set-Content -Path readme.txt
        # ((Get-Content -path readme.txt -Raw) -replace 'tempnosqlconnectionstring',$nosqlconnectionstring) | Set-Content -Path readme.txt



        ## MANGLER ALT UDENTAGET IKKE-SENSITIVT I README

        read-host "Done replacing vars in readme.txt, press enter to proceed..."


    # ################################################## replace tokens after creation #################################################
        
        #cd "./.terraform/"
        #tempazuredevopsprojectid
        #((Get-Content -path main.tf -Raw) -replace 'tempazuredevopsprojectid',$projectid) | Set-Content -Path main.tf

        #tempazurerepositoryid
        #((Get-Content -path main.tf -Raw) -replace 'tempazurerepositoryid',$repositoryId) | Set-Content -Path main.tf

        #temppipelineid
        #((Get-Content -path main.tf -Raw) -replace 'temppipelineid',$pipelineId) | Set-Content -Path main.tf

        #tempresourcegroupid
        #((Get-Content -path main.tf -Raw) -replace 'tempresourcegroupid',$resourcegroupId) | Set-Content -Path main.tf

        #tempstorageaccountid and tempstoragekey
        #((Get-Content -path main.tf -Raw) -replace 'tempstorageaccountid',$storageaccountId) | Set-Content -Path main.tf
        #((Get-Content -path main.tf -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path main.tf

        #vars for backupdbservice - done in refreshcloudvars instead
        #((Get-Content -path appservice.tf -Raw) -replace 'tempresourcename',$resourcegroupName) | Set-Content -Path appservice.tf
        #((Get-Content -path appservice.tf -Raw) -replace 'tempmyapisettingsstoragekey',$storagekey) | Set-Content -Path appservice.tf
        #((Get-Content -path appservice.tf -Raw) -replace 'tempmyapisettingsstoragecontainer','dbbackup') | Set-Content -Path appservice.tf

        #cd ..

        ## Replacing branch-policy vars
        #write-host "Replacing vars in branch-policy.json"
        #cd "./.azure/"

        # replace tempprojectname with $projectName
        #((Get-Content -path branch-policy.json -Raw) -replace 'temprepositoryid',$repositoryId) | Set-Content -Path branch-policy.json

        #cd ..

    # ################################################## run createpipeline script ##################################################

        # $scriptpath = $PWD.Path + '\scripts\createpipeline.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."


    # ################################################## run setcloudvars script ##################################################

        # $scriptpath = $PWD.Path + '\scripts\setcloudvars.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."


    ################################################## run pushtorepo script ##################################################

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
            #git push  jgdmytestyRepository 
            # git add .
            # git commit -m "created branches"
            git push $repositoryName

        # create test and production branches
            # git fetch
            # git pull
            # git checkout -b "test"
            # git checkout -b "pre-production"
            # git checkout -b "production"
            # git checkout "master"
            # git push "test"
            # git push "pre-production"
            # git push "production"
            # git branch -a

        # add master branch lock
            write-host
            write-host $PWD.Path
            write-host "Creating no push to master policy"
            az repos policy approver-count create --allow-downvotes true --blocking true --branch master --creator-vote-counts false --enabled true --minimum-approver-count 1 --repository-id $repositoryId --org $fullOrgName --project $projectName --reset-on-source-push false
        
        #az repos policy create --config '.azure\branch-policy.json' --org $fullOrgName --project $projectName
        #az storage account or-policy create -g $resourcegroupName -n $storageaccountName --policy default
        #az repos policy create --config '.azure\branch-policy.json' --org $fullOrgName --project $projectName
        
        # $scriptpath = $PWD.Path + '\scripts\pushtorepo.ps1'
        # write-host $scriptpath
        # & $scriptpath run
        # read-host "Enter to proceed..."

        Read-Host "Done configuring and pushing to git repository... press enter to continue"

    ################################################## create library variable group ##################################################
        write-host "Started creating library variablegroup..."

        #az pipelines variable-group create --name $variableGroupName --organization $fullOrgName --project $projectName --variables "subscriptionid"=$subId
        $variableGroupId = az pipelines variable-group create --name $variableGroupName --organization $fullOrgName --project $projectName --authorize --variables "subscriptionid=$subId" --output json --query "[id]"
        $variableGroupId = $variableGroupId.Replace("[","")
        $variableGroupId = $variableGroupId.Replace("]","")
        $variableGroupId = $variableGroupId.Replace(" ","")
        #"tenantid"=$tenantid "clientid"=$clientid "clientsecret"=$clientsecret "storagekey"=$storagekey "nosqlpassword"=$nosqlpassword "sqlpassword"=$sqlpassword

        #$variableGroupId = az pipelines variable-group list --group-name $resourceName+"variablegroup" --org $fullOrgName --project $projectName --output json --query "[id]"
        write-host "variableGroupId: "$variableGroupId

        read-host "Done creating library variable group... press enter to continue"

    
    ################################################## new create sensitive library variable group variables ##################################################

        write-host "Started creating library variablegroup variables..."

        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "tenantid" --value $tenantid # sensitive?
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "clientid" --value $clientid # sensitive?
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "clientsecret" --value $clientsecret # sensitive
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "storagekey" --value $storagekey # sensitive
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "nosqlpassword" --value $nosqlpassword # sensitive
        az pipelines variable-group variable create --id $variableGroupId --organization $fullOrgName --project $projectName --name "sqlpassword" --value $sqlpassword # sensitive

        read-host "Done creating library variable group variables... press enter to continue"
            
    ################################################## create library variable group variables ##################################################
        # kun values som absolut ikke må være i koden, oprettes som lib vars og replaces i replacetokens. Resten printes til readme.txt og direkte i .tf/ps1 filerne
        #write-host "Started creating library variablegroup variables..."

        # #preliminary resources variables
        #     az pipelines variable-group variable create --id $variableGroupId --name "organizationname" --value $orgName
        #     az pipelines variable-group variable create --id $variableGroupId --name "fullorganizationname" --value $fullOrgName
        #     az pipelines variable-group variable create --id $variableGroupId --name "subscriptionname" --value $subscriptionName
        #     az pipelines variable-group variable create --id $variableGroupId --name "APIURL" --value $apiurl #
        #     az pipelines variable-group variable create --id $variableGroupId --name "fullsubscriptionid" --value $fullSubId # sensitive?
        #     az pipelines variable-group variable create --id $variableGroupId --name "projectname" --value $projectName
        #     az pipelines variable-group variable create --id $variableGroupId --name "projectid" --value $projectId # sensitive?
        #     az pipelines variable-group variable create --id $variableGroupId --name "resourcename" --value $resourceName # needed???
        #     az pipelines variable-group variable create --id $variableGroupId --name "resourcegroupname" --value $resourcegroupName
        #     az pipelines variable-group variable create --id $variableGroupId --name "resourcegroupid" --value $resourcegroupId # sensitive?
        #     az pipelines variable-group variable create --id $variableGroupId --name "repositoryname" --value $repositoryName
        #     az pipelines variable-group variable create --id $variableGroupId --name "repositoryid" --value $repositoryId # sensitive?
        #     az pipelines variable-group variable create --id $variableGroupId --name "pipelinename" --value $pipelineName
        #     az pipelines variable-group variable create --id $variableGroupId --name "pipelineid" --value $pipelineId # sensitive?

        # #etc
        #     az pipelines variable-group variable create --id $variableGroupId --name "variablegroupname" --value $variableGroupName
        #     az pipelines variable-group variable create --id $variableGroupId --name "variablegroupid" --value $variableGroupId # sensitive?
            
        #     az pipelines variable-group variable create --id $variableGroupId --name "applicationname" --value $applicationName
        #     az pipelines variable-group variable create --id $variableGroupId --name "tenantid" --value $tenantid # sensitive?
        #     az pipelines variable-group variable create --id $variableGroupId --name "clientid" --value $clientid # sensitive?
        #     az pipelines variable-group variable create --id $variableGroupId --name "clientsecret" --value $clientsecret # sensitive

        #     az pipelines variable-group variable create --id $variableGroupId --name "storageaccountname" --value $storageaccountName
        #     az pipelines variable-group variable create --id $variableGroupId --name "storageaccountid" --value $storageaccountId # sensitive?
        #     az pipelines variable-group variable create --id $variableGroupId --name "storagekey" --value $storagekey # sensitive
        #     az pipelines variable-group variable create --id $variableGroupId --name "terraformcontainername" --value $terraformcontainername
        #     az pipelines variable-group variable create --id $variableGroupId --name "dbbackupcontainername" --value $dbbackupcontainername
        
        # #terraform resources variables
        #     az pipelines variable-group variable create --id $variableGroupId --name "appserviceplanname" --value $appserviceplanname
        #     az pipelines variable-group variable create --id $variableGroupId --name "webappname" --value $webappname
        #     az pipelines variable-group variable create --id $variableGroupId --name "apiappname" --value $apiappname
        #     az pipelines variable-group variable create --id $variableGroupId --name "mssqlservername" --value $mssqlservername
        #     az pipelines variable-group variable create --id $variableGroupId --name "mssqldatabasename" --value $mssqldatabasename
        #     az pipelines variable-group variable create --id $variableGroupId --name "cosmosdbaccountname" --value $cosmosdbaccountname
        #     az pipelines variable-group variable create --id $variableGroupId --name "cosmosmongodbname" --value $cosmosmongodbname

        # # hmm
        #     az pipelines variable-group variable create --id $variableGroupId --name "nosqlpassword" --value $nosqlpassword #"P%40ssw0rd" # sensitive
        #     az pipelines variable-group variable create --id $variableGroupId --name "sqlpassword" --value $sqlpassword #"P@ssw0rd" # sensitive

        # #cloud env vars
        #     az pipelines variable-group variable create --id $variableGroupId --name "sqlconnectionstring" --value $sqlconnectionstring
        #     az pipelines variable-group variable create --id $variableGroupId --name "nosqlconnectionstring" --value $nosqlconnectionstring

        #read-host "Done creating library variable group variables... press enter to continue"

    ################################################## create pipeline ##################################################
        # CREATE PIPELINE HERE
        write-host "Started creating pipeline..."

            # add variablegroup name to pipeline.yml -> ONLY VARIABLE THIS SCRIPT REPLACES -> NO need when terraforming in release? so no variable is replaced in this script
            #((Get-Content -path azure-pipelines.yml -Raw) -replace 'tempvariablegroupname',$variableGroupName) | Set-Content -Path azure-pipelines.yml

            # create pipeline
                #$pipelineDetails = az pipelines create --name $pipelinename --yml-path '\.azure\azure-pipelines.yml' --org $fullOrgName --repository-type "tfsgit" --repository $repositoryName
                #$pipelineId = az pipelines create --name $pipelinename --yml-path '\.azure\azure-pipelines.yml' --org $fullOrgName --project $projectName --repository-type "tfsgit" --repository $repositoryName --branch "master" --output json --query "[id]"
                #write-host "Started creating pipeline..."

            $pipelineDeployName = "Deploy "+$resourceName
            $pipelineDestroyName = "Destroy "+$resourceName
            az pipelines create --name $pipelineDeployName --yml-path '\azure\azure-pipelines.yml' --org $fullOrgName --project $projectName --repository-type "tfsgit" --repository $repositoryName --branch "master"
            az pipelines create --name $pipelineDestroyName --yml-path '\azure\azure-pipelines-destroy.yml' --org $fullOrgName --project $projectName --repository-type "tfsgit" --repository $repositoryName --branch "master"
                
            #$pipelineDetails = az pipelines create --name $pipelinename --yml-path '\.azure\azure-pipelines.yml' --org $fullOrgName --project $projectName --repository-type "tfsgit" --repository $repositoryName --branch "master" --output tsv 2>$null
                #write-host $pipelineDetails

            $pipelineId = az pipelines show --name $pipelineDeployName --org $fullOrgName --project $projectName --output json --query "[id]"
            $pipelineId = $pipelineId.Replace("[","")
            $pipelineId = $pipelineId.Replace("]","")
            $pipelineId = $pipelineId.Replace(" ","")
            write-host "PipelineId: "$pipelineId
            $pipelines = az pipelines list --org $fullOrgName --project $projectName --output json
            write-host "Pipelines: "$pipelines

                #write-host "Done creating pipeline..."
                
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
        write-host " - - - Step 2: Setup a Deploy apiapp Azure App Service deploy task"
        write-host " - Go to Variables > Variable groups > Link variable group"
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