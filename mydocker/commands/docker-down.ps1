Write-Host 
Write-Host "Removing containers" -ForegroundColor Cyan
Write-Host 
docker-compose down
Write-Host 
Write-Host "Containers removed" -ForegroundColor DarkGreen
Write-Host 
Read-Host "Press any key to close..."