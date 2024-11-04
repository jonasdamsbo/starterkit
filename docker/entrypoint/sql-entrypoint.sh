#!bin/bash
/opt/mssql/bin/sqlservr | /opt/mssql/bin/permissions_check.sh |

for i in {1..50};
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -d master -i /entrypoint/sql-create-db.sql
    if [ $? -eq 0 ]
    then
        echo "sql-create-db.sql completed"
        sleep 5
        /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -d master -i /entrypoint/sql-create-dummy-data.sql
        echo "sql-create-dummy-data.sql completed"
        break
    else
        echo "Waiting for app..."
        sleep 1
    fi
done