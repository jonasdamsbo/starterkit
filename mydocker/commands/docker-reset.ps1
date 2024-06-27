Write-Host 
Write-Host "Removing containers and volumes" -ForegroundColor Cyan
Write-Host 
docker-compose down --volumes
Write-Host 
Write-Host "Containers and volumes removed" -ForegroundColor DarkGreen
Write-Host 
Read-Host "Press any key to close..."