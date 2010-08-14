#-----------------------------------------------------------------------
# Title: MySQL Healthcheck
#-----------------------------------------------------------------------
# Author: Allan Clark - <napta2k@gmail.com>
#-----------------------------------------------------------------------
# Date: 25/08/08
#-----------------------------------------------------------------------
# Comment:
#       Performs a basic MySQL "Healthcheck" on a list of MySQL servers.
#       Healthcheck includes a MySQL ping and replication check.
#-----------------------------------------------------------------------

mysqlUser=
mysqlPasswd=

mysqlServers="svr1.st0len.co.za svr2.st0len.co.za"

mysqlPing=`mysqladmin -u $mysqlUser -p$mysqlPasswd -h $host ping`

for host in $mysqlServers
do
  if [[ $mysqlPing =~ "alive" ]]
    then
      printf "$host:\tping: ok\t"
    else
      printf "ping: error\t"
  fi

echo "SELECT 1" | mysql -u $mysqlUser -p$mysqlPasswd -h $host > /dev/null
  if [ $? -eq 0 ]
    then
      printf "select: ok\n"
    else
      printf "select: error\n"
  fi
done

