DROP DATABASE IF EXISTS `LOCAL`;
DROP DATABASE IF EXISTS WHOIS_MIRROR_RIPE_GRS;
DROP DATABASE IF EXISTS MAILUPDATES_LOCAL;
DROP DATABASE IF EXISTS dnscheck_local;
DROP DATABASE IF EXISTS ACL_LOCAL;
DROP DATABASE IF EXISTS INTERNALS_LOCAL;

CREATE DATABASE `LOCAL`;
CREATE DATABASE WHOIS_MIRROR_RIPE_GRS;
CREATE DATABASE MAILUPDATES_LOCAL;
CREATE DATABASE dnscheck_local;
CREATE DATABASE ACL_LOCAL;
CREATE DATABASE INTERNALS_LOCAL;

USE `LOCAL`;
source ./migrations/whois_schema.sql
source ./migrations/whois_data.sql

USE WHOIS_MIRROR_RIPE_GRS;
source ./migrations/whois_schema.sql
source ./migrations/whois_data.sql

USE MAILUPDATES_LOCAL
source ./migrations/mailupdates_schema.sql

USE ACL_LOCAL
source ./migrations/acl_schema.sql
INSERT INTO acl_limit (prefix, daily_limit, comment, unlimited_connections)
VALUES ('192.168.0.0/16', -1, 'unlimited from local', 1);
VALUES ('172.16.0.0/12', -1, 'unlimited from local', 1);
VALUES ('127.0.0.0/8', -1, 'unlimited from local', 1);
VALUES ('10.0.0.0/8', -1, 'unlimited from local', 1);

USE INTERNALS_LOCAL
source ./migrations/internals_schema.sql
source ./migrations/internals_data.sql