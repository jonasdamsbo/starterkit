Write-Host 
Write-Host "Stopping containers" -ForegroundColor Cyan
Write-Host 
docker-compose stop
Write-Host 
Write-Host "Containers stopped" -ForegroundColor DarkGreen
Write-Host 
Read-Host "Press any key to close..."