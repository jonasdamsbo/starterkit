#set download urls and filenames
$urls = 
    "https://dl.pstmn.io/download/latest/win64",
    "https://dl.pstmn.io/download/latest/win64"
$files = 
    "Postman.exe",
    "Postman2.exe"

#check directory
$folder = ".\tools-installer\"

Write-Host "Checking install folder:" -ForegroundColor Cyan

If (Test-Path -Path "$folder" -PathType Container)
{ Write-Host "Folder $folder already exists" -ForegroundColor Red}
ELSE
{
    New-Item -Path "$folder" -ItemType directory
    Write-Host "Folder $folder directory created" -ForegroundColor Green
}

Write-Host ""

# start download
For ($i=0; $i -lt $files.Length; $i++)
{
    #set variables    
    $FileUri = $urls[$i]
    #Write-Host "this $FileUri url"
    $Destination = $folder+$files[$i]
    #Write-Host "this $Destination dest"

    # set name
    $name = $files[$i].Split(".")[0]
    Write-Host "Downloading: $name" -ForegroundColor Cyan

    #start download
    If (Test-Path -Path "$Destination")
    { Write-Host "File $Destination already exists" -ForegroundColor Red}
    ELSE
    {
        Write-Host "Starting download from $FileUri" -ForegroundColor Blue
        $bitsJobObj = Start-BitsTransfer $FileUri -Destination $Destination
        Write-Host "Finished download to $Destination" -ForegroundColor Green
    }

    switch ($bitsJobObj.JobState) {

        'Transferred' {
            Complete-BitsTransfer -BitsJob $bitsJobObj
            break
        }

        'Error' {
            throw 'Error downloading'
        }
    }

    Write-Host ""
}

# start install loop
For ($i=0; $i -lt $files.Length; $i++)
{
    #set variables    
    $FileUri = $urls[$i]
    #Write-Host "this $FileUri url"
    $Destination = $folder+$files[$i]
    #Write-Host "this $Destination dest"

    # set name
    $name = $files[$i].Split(".")[0]
    Write-Host "Installing: $name" -ForegroundColor Cyan

    #set args
    $exeArgs = '/verysilent /tasks=addcontextmenufiles,addcontextmenufolders,addtopath'

    #start installer
    If (Test-Path -Path "$Destination")
    {
        Write-Host "Starting install" -ForegroundColor Blue
        Start-Process -Wait $Destination -ArgumentList $exeArgs
        Write-Host "Install finished" -ForegroundColor Green
        Write-Host ""
    }
    ELSE
    {
        Write-Host "No such file" -ForegroundColor Red
    }
}

# start remove loop
For ($i=0; $i -lt $files.Length; $i++)
{
    #set variables    
    $FileUri = $urls[$i]
    #Write-Host "this $FileUri url"
    $Destination = $folder+$files[$i]
    #Write-Host "this $Destination dest"

    # set name
    $name = $files[$i].Split(".")[0]
    Write-Host "Remove install file for: $name" -ForegroundColor Cyan

    # remove file
    If (Test-Path -Path "$Destination")
    {
        Write-Host "Removing install file" -ForegroundColor Blue
        rm -Force "$Destination"
        Write-Host "File removed" -ForegroundColor Green
        Write-Host ""
    }
    ELSE
    {
        Write-Host "No such file" -ForegroundColor Red
    }
}

#remove folder
Write-Host "Remove install folder:" -ForegroundColor Cyan
If (Test-Path -Path "$folder")
{
    Write-Host "Removing install folder" -ForegroundColor Blue
    rm -Force "$folder"
    Write-Host "Folder removed" -ForegroundColor Green
    Write-Host ""
}
ELSE
{
    Write-Host "No such folder" -ForegroundColor Red
}

# installing docker containers
Write-Host "Installing local database (MSSQL + MongoDB) docker-container:" -ForegroundColor Cyan
Write-Host "Installing docker container" -ForegroundColor Blue
./mydocker/docker-setup run
Write-Host "Docker container installed" -ForegroundColor Green
Write-Host ""

# end setup
Write-Host "Setup is complete"
Write-Host ""
Write-Host "Press any key to close..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")