# pre
cd $PWD.Path

# run clonestarterkit
$scriptpath = $PWD.Path + '\clonestarterkit.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run createrepo
$scriptpath = $PWD.Path + '\createrepo.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run replaceazurepipeline
$scriptpath = $PWD.Path + '\replaceazurepipeline.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run replaceterraform
$scriptpath = $PWD.Path + '\replaceterraform.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run replacesetupscript
$scriptpath = $PWD.Path + '\replacesetupscript.ps1'
write-host $scriptpath
& $scriptpath run
read-host "Enter to proceed..."

# run replacesetupscript
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
