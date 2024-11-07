Write-Host "starting old"
$projectName = "tempprojectname"
$orgName = "temporganizationname"
$resourceName = "tempresourcename"
$gitfolder = "$env:userprofile/Documents/GitHub/"
$repofolder = $gitfolder+$orgName
write-host $repofolder

### if existing project
## if folder not found
If (Test-Path -Path "$repofolder" -PathType Container)
{
    Write-Host "Folder $repofolder already exists" -ForegroundColor Red
}
ELSE
{
    # install git
    $ProgressPreference = 'SilentlyContinue'; 
    Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe -OutFile .\git.exe; 
    Start-Process msiexec.exe -Wait -ArgumentList '/I git.exe /quiet'; 
    Remove-Item .\git.exe

    # clone existing project from $repoName,
    write-host "Trying to clone existing project"
    git clone "https://"+"$orgName"+"@dev.azure.com/"+"$orgName"+"/"+"$projectName"+"/_git/"+"$resourceName"+"repository" $repofolder
    
    # cd existing project
    Set-Location $repofolder
    Set-Location $projectName
}

## if found,
Set-Location $PWD.Path

while($installTools -ne "x")
{
    write-host "Choose an option:"
    write-host " - Install developer tools (i)"
    write-host " - Exit program (x)"
    $installTools = read-host

    
    # run tools-installer or resource-manager
    if($installTools -eq "i")
    {
        $scriptpath = $PWD.Path + '\tools-installer.ps1'
        write-host $scriptpath
        write-host
        read-host "Developer tools script will run"
        & $scriptpath run
    }
    elseif($installTools -eq "x")
    {
        write-host "Program will exit"
    }
}
Read-Host "Enter to proceed..."