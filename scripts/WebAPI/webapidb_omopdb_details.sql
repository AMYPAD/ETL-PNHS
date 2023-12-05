-- Add omopdb details to the WebAPI db

INSERT INTO webapi.source (source_id, source_name, source_key, source_connection, source_dialect, is_cache_enabled) SELECT 2, 'AMYPAD PNHS Database', 'AMYPAD', 'jdbc:postgresql://host.docker.internal:5432/omopdb?user=webapi_sa&password=mypass', 'postgresql', 't';
INSERT INTO webapi.source_daimon(source_daimon_id, source_id, daimon_type, table_qualifier, priority) SELECT 4, 2, 0, 'cdmdatabaseschema', 0;
INSERT INTO webapi.source_daimon(source_daimon_id, source_id, daimon_type, table_qualifier, priority) SELECT 5, 2, 1, 'cdmdatabaseschema', 1;
INSERT INTO webapi.source_daimon(source_daimon_id, source_id, daimon_type, table_qualifier, priority) SELECT 6, 2, 2, 'results', 1;
INSERT INTO webapi.source_daimon(source_daimon_id, source_id, daimon_type, table_qualifier, priority) SELECT 7, 2, 5, 'temp', 0;