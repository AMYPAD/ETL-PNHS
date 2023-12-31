-- WebAPI: Set permissions on omopdb

GRANT CONNECT ON DATABASE omopdb TO webapi;
GRANT USAGE ON SCHEMA cdmdatabaseschema TO webapi;
GRANT SELECT ON ALL TABLES IN SCHEMA cdmdatabaseschema TO webapi;
ALTER DEFAULT PRIVILEGES IN SCHEMA cdmdatabaseschema GRANT SELECT ON TABLES TO webapi;
GRANT USAGE ON SCHEMA results TO webapi;
GRANT INSERT, SELECT, UPDATE, DELETE ON ALL TABLES IN SCHEMA results TO webapi;
ALTER DEFAULT PRIVILEGES IN SCHEMA results GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO webapi;
GRANT USAGE ON SCHEMA temp TO webapi;
ALTER DEFAULT PRIVILEGES IN SCHEMA temp GRANT ALL ON TABLES TO webapi;