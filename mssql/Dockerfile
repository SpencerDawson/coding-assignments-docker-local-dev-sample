FROM mcr.microsoft.com/mssql/server:2019-latest

## Set user to root
USER root

## Copy init-db.sql, init.sh, and entryypoint.sh
COPY ["init-db.sql", "init.sh", "entrypoint.sh", "/root/"]
## Copy certs
# COPY ./sample-cert.crt /usr/local/share/ca-certificates/sample-cert.crt

## Create backup and dump folders
RUN mkdir /var/opt/mssql/backup &&\
    mkdir /var/opt/mssql/dump &&\
    ## update certificates
    # cat /usr/local/share/ca-certificates/ZscalerRootCertificate-2048-SHA256.crt >> /etc/ssl/certs/ca-certificates.crt &&\
    # /usr/sbin/update-ca-certificates &&\
    ## Grant permissions for the import-data script to be executable
    chmod +x /root/init.sh

## Switch back to mssql user and run the entrypoint script
USER mssql
ENTRYPOINT [ "/bin/bash", "/root/entrypoint.sh" ]