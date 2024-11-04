Write-Host "#######################################"
Write-Host 
Write-Host "Building images" -ForegroundColor Cyan
if ($args[0] -eq "--skip-build") {
    Write-Host "--skip-build was supplied " -NoNewline
    Write-Host "skipping" -ForegroundColor DarkYellow
}
else {
    Write-Host 
    Write-Host "Building images"
    docker-compose build
    Write-Host 
    Write-Host "Done" -ForegroundColor DarkGreen -NoNewline
}
Write-Host 
Write-Host 
Write-Host "#######################################"
Write-Host 
Write-Host "Creating containers" -ForegroundColor Cyan
Write-Host 
docker-compose up -d
Write-Host 
Write-Host "Containers created" -ForegroundColor DarkGreen -NoNewline
Write-Host 
Write-Host 
Write-Host "#######################################"
Write-Host 
Write-Host "Press any key to close..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")