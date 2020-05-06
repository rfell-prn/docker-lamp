# LAMP stack built with Docker Compose

This repository can be used to deploy LAMP stack apps.

# Deploying Mac OS X Or Linux

You can use either Docker Desktop or stand up your own Docker server with Docker + Docker Compose.

Be sure to update `.env` with the proper credentials and names
for your database users, database name, and database passwords.

**Deployment**:

`bash setup-webapp.php http://github.com/your-repo.git`

**Re-deploy over your existing app (this will destory everything)**:

`bash setup-webapp.php http://github.com/your-repo.git --nuke`

**Erase everything (this will destroy everything)**:

`sudo bash remove-webapp.php`

# Windows Support:

Note, `git-bash` and other Windows bash apps will not work with this setup script due to path expansion, see here for more details [https://github.com/git-for-windows/git/issues/577](https://github.com/git-for-windows/git/issues/577).  You can deploy this using `WSL Ubuntu`, `Virtual Machine`, etc... just not using `git-bash` for Windows.

# App Settings

You can place a script called `install.sh` in the root of your app repository you are deploying to have that script ran within your container after deployment.

This is a good place to do post install configuration like populating a database or setting permissions on folders.

# If you find your missing a PHP package or App

Look in `./bin/webserver/Dockerfile` and add packages or other features you want there.