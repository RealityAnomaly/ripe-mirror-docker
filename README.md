# RIPE Mirror Docker Container

It's the RIPE mirror in a docker container.

Usage:

```
docker build -t ripe-mirror .
docker-compose up -d
```

By default, the WHOIS server runs on 127.0.0.8 on port 1043, and the HTTP API on port 1080.

The database import will run at midnight, if you want to run it immediately you can do:
```
docker exec -it ripe_mirror_mirror_1 bash
$ java -jar ./jmxterm-1.0.1-uber.jar
> open <pid>
> bean net.ripe.db.whois:name=GrsImport
> run grsImport "RIPE-GRS" "test"
#calling operation grsImport of mbean net.ripe.db.whois:name=GrsImport
#operation returns:
GRS import started
```