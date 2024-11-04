Write-Host 
Write-Host "Starting container" -ForegroundColor Cyan
Write-Host 
docker-compose start
Write-Host 
Write-Host "Containers started" -ForegroundColor DarkGreen
Write-Host 
Write-Host "Press any key to close..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")