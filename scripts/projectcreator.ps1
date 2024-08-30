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
    $scriptpath = $PWD.Path + '\chooseorganization.ps1'
    write-host $scriptpath
    & $scriptpath run #-newRepoName $newRepoName run
    read-host "Enter to proceed..."

    # run createsubscription script
    $scriptpath = $PWD.Path + '\choosesubscription.ps1'
    write-host $scriptpath
    & $scriptpath run
    read-host "Enter to proceed..."

    # run chooseproject script
    $scriptpath = $PWD.Path + '\chooseproject.ps1'
    write-host $scriptpath
    & $scriptpath run #-newRepoName $newRepoName run
    read-host "Enter to proceed..."

    # # run createrepo script
    # $scriptpath = $PWD.Path + '\createrepo.ps1'
    # write-host $scriptpath
    # & $scriptpath run
    # read-host "Enter to proceed..."

    # run replace pipeline-cloud-setup-repo script
    $scriptpath = $PWD.Path + '\replacefiles.ps1'
    write-host $scriptpath
    & $scriptpath run
    read-host "Enter to proceed..."

    # # run createpipeline script
    # $scriptpath = $PWD.Path + '\createpipeline.ps1'
    # write-host $scriptpath
    # & $scriptpath run
    # read-host "Enter to proceed..."

    # run createcloud script
    $scriptpath = $PWD.Path + '\createcloud.ps1'
    write-host $scriptpath
    & $scriptpath run
    read-host "Enter to proceed..."

    # run pushtorepo script
    $scriptpath = $PWD.Path + '\pushtorepo.ps1'
    write-host $scriptpath
    & $scriptpath run
    read-host "Enter to proceed..."

    # run install tools script
    while($installTools -ne "yes" -and $installTools -ne "no")
    {
        $userAnswer = read-host "Install developer tools? (yes/no)"
        if($userAnswer -eq "yes")
        {
            $installTools = "yes"
            $scriptpath = $PWD.Path + '\tools-installer.ps1'
            write-host $scriptpath
            write-host 
            & $scriptpath run
        }
    }
    read-host "Enter to proceed..."
}
read-host "Enter to exit..."