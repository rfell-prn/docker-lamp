# LAMP stack built with Docker Compose

This repository can be used to deploy LAMP stack apps.

You can use either Docker Desktop or stand up your own Docker server with Docker + Docker Compose.

Be sure to update `.env` with the proper credentials and names
for your database users, database name, and database passwords.

# Deploying Mac OS X Or Linux

**Note:** DO NOT append `.git` to your repo name when deploying.

**Deployment**:

```bash
bash setup-webapp.sh http://github.com/your-repo
```

**Re-deploy over your existing app (this will destory everything)**:

```bash
bash setup-webapp.sh http://github.com/your-repo --nuke
```

**Erase everything (this will destroy everything)**:

```bash
sudo bash remove-webapp.sh
```

# Windows

First disable `core.autocrlf` prior to doing anything. This will prevent git from changing line endings on scripts automatically.

```powershell
git config --global core.autocrlf false # change to true to renable after setup
```

From Powershell perform the following:

**Deployment**:

```powershell
./setup-webapp.ps1 -repo https://www.github.com/werkn/your-rep -nuke false
```

**Re-deploy over your existing app (this will destory everything)**:

```powershell
./setup-webapp.ps1 -repo https://www.github.com/werkn/your-rep -nuke true
```

**Erase everything (this will destroy everything)**:

```powershell
./remove-webapp.ps1
```

**Note on Git-Bash for Windows**, `git-bash` and other Windows bash apps will not work with this setup script due to path expansion, see here for more details [https://github.com/git-for-windows/git/issues/577](https://github.com/git-for-windows/git/issues/577).  You can deploy this using `Powershell, WSL Ubuntu, Virtual Machine`, etc... just not using `git-bash` for Windows.

# App Settings

You can place a script called `install.sh` in the root of your app repository you are deploying to have that script ran within your container after deployment.

This is a good place to do post install configuration like populating a database or setting permissions on folders.

Ensure if your working in a mixed environment (Windows/Linux) that `install.sh` uses `LF` for line endings.  Quick way to check is to open the file in `vim` and run `:set ff`.  Ensure ending is `ff=unix`, if it is not run `:set ff=unix`.

# If you find your missing a PHP package or App

Look in `./bin/webserver/Dockerfile` and add packages or other features you want there.