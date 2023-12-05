# Master script to create OMOP CDM and load AMYPAD PNHS dataset

# This two lines are only required if the schema needs to be updated
# (e.g. change in vocabulary and dependencies)
sudo -u postgres psql -d omopdb -c "DROP SCHEMA cdmdatabaseschema CASCADE;"
sudo -u postgres psql -d omopdb -c "CREATE SCHEMA cdmdatabaseschema"

# 1. OMOP CDM: Create empty schema (tables and fields)
sudo -u postgres psql -d omopdb -f /files/scripts/CDM/OMOPCDM_postgresql_5.4_ddl.sql

# 2. OMOP CDM: Add set of indexes and primary keys
sudo -u postgres psql -d omopdb -f /files/scripts/CDM/OMOPCDM_postgresql_5.4_primary_keys.sql
sudo -u postgres psql -d omopdb -f /files/scripts/CDM/OMOPCDM_postgresql_5.4_indices.sql

# 3. OMOP CDM: Load vocabularies (including custom PNHS vocabulary)
sudo -u postgres psql -d omopdb -c"\\copy cdmdatabaseschema.DRUG_STRENGTH FROM 'files/scripts/CDM/vocabularies/DRUG_STRENGTH.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"
sudo -u postgres psql -d omopdb -c"\\copy cdmdatabaseschema.CONCEPT FROM 'files/scripts/CDM/vocabularies/CONCEPT2.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"
sudo -u postgres psql -d omopdb -c"\\copy cdmdatabaseschema.CONCEPT_RELATIONSHIP FROM 'files/scripts/CDM/vocabularies/CONCEPT_RELATIONSHIP.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"
sudo -u postgres psql -d omopdb -c"\\copy cdmdatabaseschema.CONCEPT_ANCESTOR FROM 'files/scripts/CDM/vocabularies/CONCEPT_ANCESTOR.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"
sudo -u postgres psql -d omopdb -c"\\copy cdmdatabaseschema.CONCEPT_SYNONYM FROM 'files/scripts/CDM/vocabularies/CONCEPT_SYNONYM.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"
sudo -u postgres psql -d omopdb -c"\\copy cdmdatabaseschema.VOCABULARY FROM 'files/scripts/CDM/vocabularies/VOCABULARY2.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"
sudo -u postgres psql -d omopdb -c"\\copy cdmdatabaseschema.RELATIONSHIP FROM 'files/scripts/CDM/vocabularies/RELATIONSHIP.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"
sudo -u postgres psql -d omopdb -c"\\copy cdmdatabaseschema.CONCEPT_CLASS FROM 'files/scripts/CDM/vocabularies/CONCEPT_CLASS2.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"
sudo -u postgres psql -d omopdb -c"\\copy cdmdatabaseschema.DOMAIN FROM 'files/scripts/CDM/vocabularies/DOMAIN.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"

# 4. OMOP CDM: Add constrains
sudo -u postgres psql -d omopdb -f /files/scripts/CDM/OMOPCDM_postgresql_5.4_constraints.sql

# 5. AMYPAD PNHS: Upload data into schema
sudo -u postgres psql -d omopdb -f /files/scripts/pnhs2omop/person.sql
sudo -u postgres psql -d omopdb -f /files/scripts/pnhs2omop/visit_ocurrence.sql
sudo -u postgres psql -d omopdb -f /files/scripts/pnhs2omop/procedure_occurrence.sql
sudo -u postgres psql -d omopdb -f /files/scripts/pnhs2omop/measurement.sql
sudo -u postgres psql -d omopdb -f /files/scripts/pnhs2omop/observation.sql
sudo -u postgres psql -d omopdb -f /files/scripts/pnhs2omop/observation_period.sql
sudo -u postgres psql -d omopdb -f /files/scripts/pnhs2omop/location.sql
sudo -u postgres psql -d omopdb -f /files/scripts/pnhs2omop/cdm_source.sql
