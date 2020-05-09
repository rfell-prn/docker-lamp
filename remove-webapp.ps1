Write-Host -ForegroundColor Cyan "Nuking current installation..."
docker rm -f  werkn-apache-webserver
docker rm -f  werkn-mysql
docker rm -f  werkn-phpmyadmin
Remove-Item data -r -Force
Remove-Item logs -r -Force
Remove-Item www -r -Force