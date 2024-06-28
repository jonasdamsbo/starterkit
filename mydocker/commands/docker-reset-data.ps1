Write-Host 
Write-Host "Removing containers and volumes" -ForegroundColor Cyan
Write-Host 
docker-compose down --volumes
Write-Host 
Write-Host "Containers and volumes removed" -ForegroundColor DarkGreen
Write-Host 
Write-Host "Press any key to close..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")