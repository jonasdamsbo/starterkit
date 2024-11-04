Write-Host 
Write-Host "Containers" -ForegroundColor Cyan
Write-Host 
docker ps
Write-Host 
Write-Host 
Write-Host "Press any key to close..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")