#!bin/bash
/opt/mssql/bin/sqlservr | /opt/mssql/bin/permissions_check.sh | /database/import-data.sh
