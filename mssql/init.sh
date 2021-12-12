#!/bin/sh
# Typically SQL Server takes about 5-10 seconds to start up
sleep 20s

# grep -q "Service Broker manager has started"
# 2021-08-05 01:13:17.78 spid27s Service Broker manager has started.

# Run initialization T-SQL
/opt/mssql-tools/bin/sqlcmd -U SA -P ${SA_PASSWORD} -i /root/init-db.sql