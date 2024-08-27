# pre
write-host "OBS!!! READ BEFORE PROCEEDING" -ForegroundColor Red
write-host "Make sure you have a microsoft account, and that it is setup to be able to access:" -ForegroundColor Yellow
write-host " - Azure DevOps at: https://dev.azure.com/" -ForegroundColor Yellow
write-host " - Azure Cloud at: https://portal.azure.com/" -ForegroundColor Yellow
write-host ""
write-host "Come back after you have verified that you can access both platforms with your microsoft account," -ForegroundColor Yellow
write-host "and created a new organization in Azure DevOps." -ForegroundColor Yellow
write-host ""
read-host "Press enter to proceed..."

cd $PWD.Path

# run chooseorganization script
$scriptpath = $PWD.Path + '\chooseorganization.ps1'
write-host $scriptpath
& $scriptpath run #-newRepoName $newRepoName run
read-host "Enter to proceed..."

# run chooseproject script
$scriptpath = $PWD.Path + '\chooseproject.ps1'
write-host $scriptpath
& $scriptpath run #-newRepoName $newRepoName run
read-host "Enter to proceed..."

# # run clonestarterkit script <-- move to setup
# $scriptpath = $PWD.Path + '\clonestarterkit.ps1'
# write-host $scriptpath
# & $scriptpath run #-newRepoName $newRepoName run
# read-host "Enter to proceed..."

# # run createsubscription script
# $scriptpath = $PWD.Path + '\createsubscription.ps1'
# write-host $scriptpath
# & $scriptpath run
# read-host "Enter to proceed..."

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
