Write-Host 
Write-Host "Stopping containers" -ForegroundColor Cyan
Write-Host 
docker-compose stop
Write-Host 
Write-Host "Containers stopped" -ForegroundColor DarkGreen
Write-Host 
Write-Host "Press any key to close..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")