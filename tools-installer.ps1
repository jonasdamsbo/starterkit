#set download urls and filenames
$urls = 
    "https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=community&channel=Release&version=VS2022&source=VSLandingPage&cid=2030:9d111845fd3c400d9b46923374422485",
    "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user",
    "https://dl.pstmn.io/download/latest/win64",
    "https://central.github.com/deployments/desktop/desktop/latest/win32",
    "https://downloads.mongodb.com/compass/mongodb-compass-1.43.4-win32-x64.exe",
    "https://aka.ms/ssmsfullsetup",
    "https://go.microsoft.com/fwlink/?linkid=2274898",
    "https://drive.usercontent.google.com/download?id=1cx_jhuthZJVpZevvtPwLYdUQYvBUSZVR&export=download&authuser=0&confirm=t&uuid=19d4b1a8-766a-43ec-af8d-d359dabe4f77&at=APZUnTXnXmYGBSHefMsJ5qydo108%3A1719878149675",
    "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64",
    "https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe",
    "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module"
$files = 
    "VisualStudio.exe",
    "VSCode.exe",
    "Postman.exe",
    "GithubDesktop.exe",
    "MongoDBCompass.exe",
    "SQLServerManagementStudio.exe",
    "AzureDataStudio.exe",
    "Trello.exe",
    "Discord.exe",
    "GoogleDrive.exe",
    "DockerDesktop.exe"
$choices = "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "X", "Y"

#choose what to install or all or exit
do {
    do {
        cls
        #write-host ""
        #write-host "****************************" -ForegroundColor Cyan
        #write-host "**       Main Menu        **" -ForegroundColor Cyan
        #write-host "****************************" -ForegroundColor Cyan
        #write-host ""
        write-host "PROGRAMS" -ForegroundColor Cyan
        write-host "  A - Install VisualStudio" -NoNewline
	write-host " <--- Choose to install these 2 workflows: ASP.NET and web development + Azure development" -ForegroundColor Yellow
        write-host "  B - Install VSCode"
        write-host "  C - Install Postman"
        write-host "  D - Install GithubDesktop"
        write-host "  E - Install MongoDBCompass"
        write-host "  F - Install SQLServerManagementStudio"
        write-host "  G - Install AzureDataStudio"
        write-host "  H - Install Trello"
        write-host "  I - Install Discord"
        write-host "  J - Install GoogleDrive"
        write-host "  K - Install DockerDesktop" -NoNewline
	write-host " <--- Requires 'O - Install WSL'" -ForegroundColor Yellow
        write-host "  L - Install DockerContainers" -NoNewline
	write-host " <--- Requires 'K - Install DockerDesktop' + 'N - Clone project'" -ForegroundColor Yellow
        write-host ""
        write-host "PREREQUISITES" -ForegroundColor Cyan
        write-host "  M - Install git"
        write-host "  N - Clone project" -NoNewline
	write-host " <--- Requires 'M - Install git'" -ForegroundColor Yellow
        write-host "  O - Install WSL" -NoNewline
	write-host " <--- Requires PC restart afterwards" -ForegroundColor Yellow
        write-host ""
        write-host "Z - Install ALL prerequisites"
        write-host "Y - Install ALL programs"
        #write-host ""
        write-host "X - Exit" -ForegroundColor Red
    
        write-host ""
        write-host "OBS!!! If you don't have the project and this is your first time running the script:" -ForegroundColor Yellow
	write-host " - Choose 'Z' to install prerequisites" -ForegroundColor Yellow
	write-host " - If you installed WSL, restart your PC before installing programs" -ForegroundColor Yellow
	write-host ""
        $answer = read-host "Type one or multiple characters"
    
        $ok = $answer -match '[ABCDEFGHIJKLMNOYX]+$'
        if ( -not $ok) {write-host "Invalid selection"
                        sleep 2
                        write-host ""
                        }
    } until ($ok)
        
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        
    if($answer -notmatch "X")
    {
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

        # check for prerequisites
        if($answer -match "M" -or $answer -match "N" -or $answer -match "O" -or $answer -match "Z" )
        {
            #pre prequsities
            Write-Host "Preparing prerequisites:" -ForegroundColor Cyan
            Write-Host " - Install Git" -ForegroundColor Cyan
            Write-Host " - Clone project" -ForegroundColor Cyan
            Write-Host " - Install WSL" -ForegroundColor Cyan
            Write-Host " - Restart PC" -ForegroundColor Cyan
            Write-Host 

            if($answer -match "M" -or $answer -match "Z")
            {
                Write-Host ""

                #git download
                $gitexe = $folder+"git.exe"
                $giturl = "https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe"
                Write-Host "Starting download from $giturl" -ForegroundColor Blue
                $bitsJobObj = Start-BitsTransfer $giturl -Destination $gitexe
                Write-Host "Finished download to $gitexe" -ForegroundColor Green
                Write-Host 

                #git install
                Write-Host "Installing git" -ForegroundColor Blue
                Start-Process -Wait $gitexe
                Write-Host "Finished installing git" -ForegroundColor Green
                Write-Host 

                #git remove
                Write-Host "Removing install file and folder" -ForegroundColor Blue
                rm -Force "$gitexe"
                rm -Force "$folder"
                Write-Host "File and folder removed" -ForegroundColor Green
                Write-Host ""
            }

            if($answer -match "N" -or $answer -match "Z")
            {
                # git folders
                $gitfolder = "$env:userprofile/Documents/GitHub/"
                If (Test-Path -Path "$gitfolder" -PathType Container)
                { Write-Host "Folder $gitfolder already exists" -ForegroundColor Red}
                ELSE
                {
                    New-Item -Path "$gitfolder" -ItemType directory
                    Write-Host "Folder $gitfolder directory created" -ForegroundColor Green
                }
                Write-Host 

                $repofolder = $gitfolder+"mywebrepo"
                If (Test-Path -Path "$repofolder" -PathType Container)
                { Write-Host "Folder $repofolder already exists" -ForegroundColor Red}
                ELSE
                {
                    New-Item -Path "$repofolder" -ItemType directory
                    Write-Host "Folder $repofolder directory created" -ForegroundColor Green
                    
                    #git clone
                    Write-Host "Cloning repo" -ForegroundColor Blue
                    cd $repofolder
                    git clone https://github.com/jonasdamsbo/mywebrepo.git $repofolder
                    Write-Host "Finished cloning repo" -ForegroundColor Green
                    Write-Host 
                }
                Write-Host 
            }

            if($answer -match "O" -or $answer -match "Z")
            {
                # install WSL
                Write-Host "Start installing WSL:" -ForegroundColor Blue
                Write-Host "If ubuntu starts, CTRL+D to escape" -ForegroundColor Yellow
                wsl --install
                Write-Host "WSL installed" -ForegroundColor Green
                wsl --set-default-version 2
                Write-Host "WSL set to v2" -ForegroundColor Green
                wsl --update
                Write-Host "WSL updated" -ForegroundColor Green
                Write-Host "Finished installing WSL."
                Read-Host "Please exit the installer and restart the pc before proceeding"
                Read-Host "Please exit the installer and restart the pc before proceeding"
                Read-Host "Please exit the installer and restart the pc before proceeding"
                exit
            }
        }
        else
        {
            # start looping through choices
            if($answer -notmatch "L")
            {
                For ($i=0; $i -lt $files.Length; $i++)
                {
                    if($answer -match $choices[$i] -or $answer -match "Y")
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


                        # start install

                        #set args
                        $exeArgs = '/verysilent /tasks=addcontextmenufiles,addcontextmenufolders,addtopath'

                        Write-Host "Installing: $name" -ForegroundColor Cyan

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

                        
                        # start remove

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
            }


            # installing docker containers

            if($answer -match "L" -or $answer -match "Y")
            {
                Write-Host "Installing local database (MSSQL + MongoDB) docker-container:" -ForegroundColor Cyan
                Write-Host "Installing docker container" -ForegroundColor Blue
                #./mydocker/docker-setup run
		cd $env:userprofile/Documents/GitHub/mywebrepo/mydocker/
		& $env:userprofile/Documents/GitHub/mywebrepo/mydocker/docker-setup run

                #*/Documents/GitHub/mywebrepo/mydocker/docker-setup run
		#cd "$env:userprofile\Documents\GitHub\mywebrepo\mydocker\"
		#docker-setup run
		#$mypath = $env:userprofile+"/Documents/GitHub/mywebrepo/mydocker"
		#Write-Host "$mypath"
		#cd $mypath
		#docker-setup run
		#$mypath/docker-setup run
		#$env:userprofile+"/Documents/GitHub/mywebrepo/mydocker/docker-setup" run
		#Write-Host "$env:userprofile"
		#Write-Host "$env:userprofile\Documents\GitHub\mywebrepo\mydocker\"
		#$mypath = "$env:userprofile/Documents/GitHub/mywebrepo/mydocker/docker-setup"
		#$mypath run
                
		Write-Host "Docker container installed" -ForegroundColor Green
                Write-Host ""
            }
        }

    }

    # end setup
    Write-Host "Setup is complete"
    Write-Host ""
    Write-Host "Press any key to close..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

} until ( $answer -match 'X' )