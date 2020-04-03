#!/bin/bash
export MYSQL_HOST=$DB_HOST
export MYSQL_PWD=$DB_PWD

while ! nc -z $DB_HOST 3306;
do
    echo "waiting for DB to come up";
    sleep 5;
done;

if [ ! -f /app/var/.migrated ]; then
    echo "running migrations"
    mysql -u $DB_USER < /app/migrate.sql
    if [ $? -ne 0 ]; then
        echo "failed to run migrations"
        exit 1
    fi

    echo "migrations complete"
    touch /app/var/.migrated
fi

JMXPORT="1099"
MEM="-Xms8G -Xmx16G"
JAVA_OPT="-XX:-HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/export/tmp -XX:MaxPermSize=128m -XX:ErrorFile=var/hs_err_pid%p.log -Djsse.enableSNIExtension=false"
GC_LOG="-XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC -Xloggc:var/gc.log"
JMX="-Dcom.sun.management.jmxremote -Dhazelcast.jmx=true -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=${JMXPORT}"

### Final assembled command line
java -Dwhois $JAVA_OPT $JMX $MEM -Dwhois.config=properties -Dhazelcast.config=hazelcast.xml -Dlog4j.configuration=file:log4j.xml -jar whois.jar