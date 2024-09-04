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

    # run chooseorganization script
    $scriptpath = $PWD.Path + '\scripts\chooseorganization.ps1'
    write-host $scriptpath
    & $scriptpath run #-newRepoName $newRepoName run
    read-host "Enter to proceed..."

    # run createsubscription script
    $scriptpath = $PWD.Path + '\scripts\choosesubscription.ps1'
    write-host $scriptpath
    & $scriptpath run
    read-host "Enter to proceed..."

    # run chooseproject script
    $scriptpath = $PWD.Path + '\scripts\chooseproject.ps1'
    write-host $scriptpath
    & $scriptpath run #-newRepoName $newRepoName run
    read-host "Enter to proceed..."

    # run chooseresources script
    $scriptpath = $PWD.Path + '\scripts\chooseresources.ps1'
    write-host $scriptpath
    & $scriptpath run #-newRepoName $newRepoName run
    read-host "Enter to proceed..."

    # # run createrepo script
    # $scriptpath = $PWD.Path + '\scripts\createrepo.ps1'
    # write-host $scriptpath
    # & $scriptpath run
    # read-host "Enter to proceed..."

    # run replace pipeline-cloud-setup-repo script
    $scriptpath = $PWD.Path + '\scripts\replacefiles.ps1'
    write-host $scriptpath
    & $scriptpath run
    read-host "Enter to proceed..."

    # # run createpipeline script
    # $scriptpath = $PWD.Path + '\scripts\createpipeline.ps1'
    # write-host $scriptpath
    # & $scriptpath run
    # read-host "Enter to proceed..."

    # run refreshcloudips script
    # $scriptpath = $PWD.Path + '\scripts\refreshcloudips.ps1'
    # write-host $scriptpath
    # & $scriptpath run
    # read-host "Enter to proceed..."

    # run pushtorepo script
    $scriptpath = $PWD.Path + '\scripts\pushtorepo.ps1'
    write-host $scriptpath
    & $scriptpath run
    read-host "Enter to proceed..."

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