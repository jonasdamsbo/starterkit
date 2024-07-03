Write-Host 
if ($args[0] -eq "--skip-build") {
    Write-Host "--skip-build was supplied " -NoNewline
    Write-Host "skipping" -ForegroundColor DarkYellow
}
else {
    Write-Host "Building images" -ForegroundColor Cyan
    docker-compose build
    Write-Host "Done" -ForegroundColor DarkGreen
}
Write-Host 
Write-Host "Creating containers" -ForegroundColor Cyan
docker-compose up -d
Write-Host "Containers created" -ForegroundColor DarkGreen
Write-Host 
Write-Host "Stopping containers" -ForegroundColor Cyan
docker-compose stop
Write-Host "Containers stopped" -ForegroundColor DarkGreen
Write-Host 
Write-Host "Press any key to close..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")