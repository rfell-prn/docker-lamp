param (
    [string]$nuke = "false",
    [Parameter(Mandatory=$true)][string]$repo
 )

#install our git repo, where $1 is the path to GitHub repo to install

#if nuke option is set, blow away all containers
#erase existing installation

if ($nuke -eq $true) {
    Write-Host -ForegroundColor Cyan "Nuking current installation..."
    docker rm -f  werkn-apache-webserver
    docker rm -f  werkn-mysql
    docker rm -f  werkn-phpmyadmin
    Remove-Item data -r -Force
    Remove-Item logs -r -Force
    Remove-Item www -r -Force
}

#setup folders, clone repo
mkdir data -Force
mkdir data/mysql -Force
mkdir logs -Force
mkdir logs/mysql -Force
mkdir logs/apache2 -Force
mkdir logs/php -Force
mkdir www -Force

Set-Location www

#stop windows line endings from modifying anything in our src folder
#this will mess up line endings for scripts copied into containers
#ie: windows line endings appended to scripts and files we
#plan on running in a linux container
git config --global core.autocrlf false

#clone repo
git clone $repo

#get our folder name, should have been create from repo path (last portion of)
#https://www.github.com/username/>>>>repo-name-here<<<<
$repoFolderName=Split-Path $repo -Leaf

#change into our www dir
#all dockerized apps use branch docker-setup,
#check that branch out
Set-Location "$repoFolderName"

#dump the readme to the console if it exists in the repo specifically we use an html comment
#to communicate post config operations when using docker
#ie: somewhere in your readme add #docker-post-install-msg: YOUR MESSAGE HERE, URL, ETC...
if (Test-Path -path README.md)
{
	Write-Host -ForegroundColor Yellow "Dumping README.md docker-post-install-msg for repo ($repoFolderName)"
	$msg = Get-Content .\README.md | Select-String -Pattern "docker-post-install-msg"
    Write-Host -ForegroundColor Cyan $msg.Line
}

Set-Location ../..

Write-Host -ForegroundColor Yellow "Bringup up LAMP stack + installed web app for ($repoFolderName)"

# bring up docker containers + app
docker-compose up -d

# make sure container is running before proceeding
Write-Host -ForegroundColor Yellow "Waiting for docker containers to come up before proceeding..."
Start-Sleep -Seconds 20

#if www/appname has a install.sh, run it it contains post config scripts
if (Test-Path -Path "./www/$repoFolderName/install.sh")
{
	Write-Host -ForegroundColor Yellow "Running post install script for app: $repoFolderName"
	docker exec -it werkn-apache-webserver bash "/var/www/html/$repoFolderName/install.sh"
}

#make sure our web app is owned by www-data (fix for upload folder permissions)
docker cp ./bin/webserver/apache2/configure-permissions.sh werkn-apache-webserver:/etc/apache2/

#copy into web server config script for .htpasswd
docker cp ./bin/webserver/apache2/build-sites-enabled-confs.sh werkn-apache-webserver:/etc/apache2/

#run script in interactive shell
docker exec -it werkn-apache-webserver bash /etc/apache2/configure-permissions.sh
docker exec -it werkn-apache-webserver bash /etc/apache2/build-sites-enabled-confs.sh

#re-enable line endings in case the user wants it
git config --global core.autocrlf true
