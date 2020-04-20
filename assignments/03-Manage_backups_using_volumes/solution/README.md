

Task 1) 

Create the data volume for MySQL

```console
$ docker volume create db-vol
db-vol
```

Run a MySQL container

```console
$ docker run \
    --name mysql-container \
    --mount source=db-vol,target=/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=mypass \
    mysql:latest
Unable to find image 'mysql:latest' locally
latest: Pulling from library/mysql
...
Status: Downloaded newer image for mysql:latest
...
2020-04-17T16:07:11.803868Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.19'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
```

Task 2) 

Run a new container to backup MySQL datafiles

```console
$ docker run \
    --rm \
    --name mysql-backupper \
    --mount source=db-vol,target=/var/lib/mysql,readonly \
    --mount type=bind,source=$(pwd),target=/backups \
    busybox:latest \
    tar czvf /backups/mysql_datafiles.tar.gz /var/lib/mysql
```

List the backup file on local machine

```console
$ ls -l mysql_datafiles.tar.gz 
-rw-r--r--  1 denismaggiorotto  staff  11619892 17 Apr 18:18 mysql_datafiles.tar.gz
```

Look inside the backup file 

```console
$ tar tvf mysql_datafiles.tar.gz 
...
-rw-r-----  0 999    999     81920 17 Apr 18:07 var/lib/mysql/#innodb_temp/temp_2.ibt
-rw-r-----  0 999    999     81920 17 Apr 18:07 var/lib/mysql/#innodb_temp/temp_6.ibt
-rw-r--r--  0 999    999      1112 17 Apr 18:06 var/lib/mysql/server-cert.pem
-rw-r-----  0 999    999  50331648 17 Apr 18:07 var/lib/mysql/ib_logfile0
-rw-r-----  0 999    999      5552 17 Apr 18:07 var/lib/mysql/ib_buffer_pool
-rw-r--r--  0 999    999      1112 17 Apr 18:06 var/lib/mysql/client-cert.pem
-rw-r-----  0 999    999        56 17 Apr 18:06 var/lib/mysql/auto.cnf
drwxr-x---  0 999    999         0 17 Apr 18:06 var/lib/mysql/sys/
-rw-r-----  0 999    999    114688 17 Apr 18:07 var/lib/mysql/sys/sys_config.ibd
-rw-r--r--  0 999    999      1112 17 Apr 18:06 var/lib/mysql/ca.pem
-rw-r-----  0 999    999  50331648 17 Apr 18:06 var/lib/mysql/ib_logfile1
-rw-r-----  0 999    999  12582912 17 Apr 18:07 var/lib/mysql/ibdata1
-rw-r-----  0 999    999        32 17 Apr 18:07 var/lib/mysql/binlog.index
-rw-r-----  0 999    999  12582912 17 Apr 18:07 var/lib/mysql/undo_001
-rw-------  0 999    999      1676 17 Apr 18:06 var/lib/mysql/client-key.pem
```

