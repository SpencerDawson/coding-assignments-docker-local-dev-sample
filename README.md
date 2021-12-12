# Docker Local Dev Sample

Sample dev environment. Nothing special, other than being some boiler plate for local dev.
<br/><br/>

## Dependancies

---
The following is required for this environment

- Docker (Docker Desktop, etc)
- docker-compose v2.x.x
<br/><br/>

## Project Source

---
Usually, I use an init script to sym link a project into the dev environment. Usually allows me to keep project source isolated from whatever base docker enviroment I am using for the project.
<br/><br/>

## ENV files need to be generated.

---
envs for docker-compose should be generated. These are used for the mssql instance and the php instance. Typically they contain sensitive information we don't want added to git. If passwords or keys are found within a repository, they should be changed and removed from the git workflow and saved as a local file (files can be ignored in `.gitignore`)
<br/><br/>

## Sample ENV

---
`sqlserver.env`
```
ACCEPT_EULA=Y
MSSQL_PID=Developer
MSSQL_BACKUP_DIR=/var/opt/mssql/backup
MSSQL_DATA_DIR=/var/opt/mssql/data
MSSQL_LOG_DIR=/var/opt/mssql/log
MSSQL_DUMP_DIR=/var/opt/mssql/dump
```

`sapassword.env`
```
SA_PASSWORD=<password>
```

`laravel.env`
```
APP_NAME="Sample App"
APP_ENV=local
APP_KEY=<key>
APP_URL=http://localhost

LOG_CHANNEL=stack

####
# Other
####

BROADCAST_DRIVER=log
CACHE_DRIVER=file
QUEUE_CONNECTION=sync
#SESSION_DRIVER=database
SESSION_CONNECTION=DB2
SESSION_LIFETIME=120

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=null
MAIL_FROM_NAME="${APP_NAME}"
```

`laraveldb.env`
```
#############################
## Laravel Connection Vars ##
#############################
DB_CONNECTION=<connection name>
DB_DATABASE=<DB1|DB2>

##################################
## Docker MSSQL Connection Vars ##
##################################
# docker uses container name and internal ports for connection (mssql,1433)
DB_HOST=mssql
DB_PORT=1433
DB_USERNAME=SA
DB_PASSWORD=<password>

#################################
## Local MSSQL Connection Vars ##
#################################
#DB_HOST=<Host IP>
#DB_PORT=1433
#DB_USERNAME=SA
#DB_PASSWORD=<password>

####################################
## Generic MSSQL Connection Vars ##
####################################
#DB_HOST=<Host name>
#DB_PORT=<port>
#DB_USERNAME=<username>
#DB_PASSWORD=<password>
```