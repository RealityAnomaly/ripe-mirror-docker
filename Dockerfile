FROM debian:buster
COPY ./app/* /app/

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/

RUN apt-get update && apt-get install -y \
    make \
    gcc \
    git \
    maven \
    netcat \
    procps \
    adoptopenjdk-8-hotspot \
    mariadb-client-10.3 \
    mariadb-server-10.3

RUN mkdir /tmp/build
WORKDIR /tmp/build

RUN git clone https://github.com/RIPE-NCC/whois
WORKDIR /tmp/build/whois
RUN mvn clean install -Prelease
RUN for file in whois-db/target/whois-db-*.jar ; do cp "$file" "/app/whois.jar" ; done \
    && cp tools/hazelcast.xml tools/log4j.xml tools/logrotate.conf /app

RUN mkdir /app/migrations && cp -r whois-commons/src/main/resources/*.sql /app/migrations/
RUN rm -r /tmp/build

WORKDIR /app
CMD /app/entrypoint.sh