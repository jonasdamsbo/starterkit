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

# prompt desired repo/project name
$repoName = read-host "What do you want to name your new project?"

# run clonestarterkit script
$scriptpath = $PWD.Path + '\clonestarterkit.ps1'
write-host $scriptpath
& $scriptpath run #-newRepoName $newRepoName run
read-host "Enter to proceed..."

# run createrepo script
$scriptpath = $PWD.Path + '\createrepo.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run replaceazurepipeline script
$scriptpath = $PWD.Path + '\replaceazurepipeline.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run replaceterraform script
$scriptpath = $PWD.Path + '\replaceterraform.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run replacesetupscript script
$scriptpath = $PWD.Path + '\replacesetupscript.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run pushtorepo script
$scriptpath = $PWD.Path + '\pushtorepo.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run createterraform script
$scriptpath = $PWD.Path + '\createterraform.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run createpipeline script
$scriptpath = $PWD.Path + '\createpipeline.ps1'
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
