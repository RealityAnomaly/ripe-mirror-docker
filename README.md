# RIPE Mirror Docker Container

It's the RIPE mirror in a docker container.

Usage:

```
docker build -t ripe-mirror .
docker-compose up -d
```

By default, the WHOIS server runs on `127.0.0.8` on port `1043`, and the HTTP API on port `1080`. You can modify the server config by editing whois.properties (this will require a container restart to take effect.)

Two volumes are created - `mariadb_data` to hold the database, and `mirror_data` to hold GRS imports, exports, and miscellaneous logfiles.

The database import will run at midnight, if you want to run it immediately you can download jmxterm to /app, rebuild the container and do:
```
docker exec -it ripe_mirror_mirror_1 bash
$ java -jar ./jmxterm-1.0.1-uber.jar
> open <pid>
> bean net.ripe.db.whois:name=DailyScheduler
> run runDailyScheduledTasks
#calling operation runDailyScheduledTasks of mbean net.ripe.db.whois:name=DailyScheduler with params []
```