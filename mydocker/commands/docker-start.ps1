Write-Host 
Write-Host "Starting container" -ForegroundColor Cyan
Write-Host 
docker-compose start
Write-Host 
Write-Host "Containers started" -ForegroundColor DarkGreen
Write-Host 
Read-Host "Press any key to close..."