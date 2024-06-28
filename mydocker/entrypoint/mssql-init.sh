#!bin/bash
/opt/mssql/bin/sqlservr | /opt/mssql/bin/permissions_check.sh |

for i in {1..50};
do
    sleep 10
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -d master -i /entrypoint/sql-create-db.sql
    if [ $? -eq 0 ]
    then
        echo "sql-create-db.sql completed"
        sleep 10
        /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -d master -i /entrypoint/sql-create-dummy-data.sql
        break
    else
        echo "Waiting for app..."
        sleep 1
    fi
done