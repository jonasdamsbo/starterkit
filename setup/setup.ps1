Write-Host "Building images"
if ($args[0] -eq "--skip-build") {
    Write-Host "--skip-build was supplied " -NoNewline
    Write-Host "skipping" -ForegroundColor DarkYellow
}
else {
    docker-compose build
    Write-Host "Done" -ForegroundColor DarkGreen -NoNewline
    Write-Host " building images"
}
Write-Host 

Write-Host "Spinning up containers (database)"
docker-compose up -d
Write-Host "Done" -ForegroundColor DarkGreen -NoNewline
Write-Host " spinning up containers"
Write-Host 

#done
Write-Host "All done." -ForegroundColor DarkGreen
Write-Host
Write-Host "You can now connect to ssms" -ForegroundColor Magenta
Write-Host "Server name: " -ForegroundColor Magenta -NoNewline
Write-Host "localhost,11433" -ForegroundColor DarkGreen
Write-Host "Authentication: " -ForegroundColor Magenta -NoNewline
Write-Host "SQL Server Authentication" -ForegroundColor DarkGreen
Write-Host "Login: " -ForegroundColor Magenta -NoNewline
Write-Host "sa" -ForegroundColor DarkGreen
Write-Host "Password: " -ForegroundColor Magenta -NoNewline
Write-Host "P@ssw0rd" -ForegroundColor DarkGreen
Write-Host
Write-Host "Happy coding :)" -ForegroundColor Magenta