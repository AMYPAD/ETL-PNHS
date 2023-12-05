# Conversion of the AMYPAD PNHS data to OMOP CDM

*Notes:*
At this moment, it is not possible to support multiple database sachems in ADDI Workbench. Therefore the OMOP CDM schema has been set up in a PostgreSQL DB in the a Linux VM.


*RStudio*
To allow the installation of `Tidyverse` the following libraries were required `libfribidi-dev` and `libharfbuzz-dev` was required via `sudo apt-get install`

## 1. Setup database and connections

### 1.1 Install basic packages in Linux VM

```
sudo apt update
sudo apt install postgresql postgresql-contrib
```

### 1.2 Adjust access rights to the database

1. Edit '/etc/postgresql/10/main/pg_hba.conf'

`sudo nano /etc/postgresql/10/main/pg_hba.conf`

2. Add line and save file

`host all all 127.0.0.1/32  trust`

3. Restart server

`sudo service postgresql restart`

### 1.3 Create database

```
sudo -u postgres psql
CREATE DATABASE omopdb
CREATE SCHEMA cdmdatabaseschema;
```

### 1.4 Connect RStudio via ODBC 

1. Install ODBC in Linux VM

`sudo apt-get odbc-postgresql`

2. Open list of connections

`sudo nano /etc/odbc.ini`

3. Add following lines and save the file

```
[OMOP]
Driver = PostgreSQL Unicode
Database = omopdb
Servername = localhost
Username = postgres
```

4. In R Studio, create connection by running

`con <- DBI::dbConnect(odbc::odbc(), "OMOP")`

## 2. Vocabulary Setup

### 2.1 Download OMOP CDM vocabularies from Athena (Basic set)

Download the basic set of vocabularies from [Athena](https://athena.ohdsi.org).

- SNOMED
- LOINC
- Gender
- Race
- Ethnicity
- OMOP Extension
- UK Biobank
- OMOP Genomic

Other required vocabularies, such as *UCUM*, are included by default.

### 2.2 Update set with custom AMYPAD PNHS vocabulary

This can be done by running the following script from the Linux VM terminal.

`Rscript files/scripts/pnhs2omop/update_vocabularies.R`


This will create new versions of the vocabulary files:

- CONCEPT2.csv
- VOCABULARY2.csv
- CONCEPT_CLASS2.csv

## 3. Adjust original OMOP CDM SQL files

1. \*_ddl.sql: Change @cdmDatabaseSchema to cdmdatabaseschema
2. \*_primary_keys: Change @cdmDatabaseSchema to cdmdatabaseschema
2. \*_indices: Change @cdmDatabaseSchema to cdmdatabaseschema
4. \*_constraints:  Change @cdmDatabaseSchema to cdmdatabaseschema

One line of code gave an error message, so it was commented out: 

`ALTER TABLE COHORT_DEFINITION ADD CONSTRAINT fpk_COHORT_DEFINITION_cohort_definition_id FOREIGN KEY (cohort_definition_id) REFERENCES COHORT (COHORT_DEFINITION_ID);`

This requires further investigation, as we are not sure what the reason is (maybe that *cohort_definition_id* is not set as a primary key for cohort?). Although, as far as we understand, it should be possible to reference a column that is not a primary key.

## 4. Staging AMYPAD PNHS data

Before uploading the dataset into the OMOP CDM tables, it is needed to create an staging set of tables to facilitate the transformation.

### 4.1 Create schema

First, we will create an independent schema to store the tables

`sudo -u postgres psql -d omopdb -c "CREATE SCHEMA pnhs"`

### 4.2 Preprocess AMYPAD PNHS dataset

To create the staging tables, the following script was executed:

`/files/scripts/pnh2omop/preprocess_pnhs.R`

## 5. Create OMOP CDM scheme and populated with AMYPAD PNHS data

This can be done by running the following script:

`files/scripts/pnh2omop/master_script.sh`

Briefly, the steps performed by the script are:
1. OMOP CDM: Create empty schema
2. OMOP CDM: Add the primary keys and indices
3. OMOP CDM: Load vocabularies
4. OMOP CDM: Add constrains
5. AMYPAD PNHS: Upload data into schema

# 6. Quality Control

- Unless otherwise stated, all work is done in the workspace Linux VM.
- DB Connection requires a JDBC driver.
    - Downloaded the Java 8 from https://jdbc.postgresql.org/download/
    - Place it in `/files/jbdcdriver/`

- First, a new schema to store the results was created

`sudo -u postgres psql -d omopdb -c "CREATE SCHEMA results"`

## 6.1 Achilles (OHDSI)

### 6.1.1 Installation

- Could be installed from CRAN
- Installation needed also `rJava`, `SqlRender`, and `DatabaseConnector` packages
- rJava package gave problems, and was eventually installed with jri disabled: `install.packages("rJava, configure.args="--disable-jri")`
- Copied and completed code from the [Achilles Manual](https://cloud.r-project.org/web/packages/Achilles/vignettes/RunningAchilles.pdf), and saved as `/files/scripts/QC/achilles.r`
- Added loading of required R packages. Added line `options(connectionObserver = NULL)` to get rid of error message (see https://forums.ohdsi.org/t/getting-an-error-running-achilles/19224).
- Added location of JDBC driver to `/files/scripts/QC/achilles.r`.
- Added `optimizeAtlasCache = TRUE` to `/files/scripts/QC/achilles.r`.

### 6.1.2 Execution

`/files/scripts/QC/achilles.r`.


## 6.2 DataQualityDashboard (OHDSI)

### 6.2.1 Installation

- Not in CRAN, and GitHub is not accessible from the workspace, so `remotes::install_github()` cannot be used
- Installed DataQualityDashboard in local RStudio, zipped folder, uploaded to the workspace, unzipped, and moved to `/usr/local/lib/R/site-library`
- Note: Local R Studio has R version 4.3.1. A warning was shown, buy doesn't seem to cause any issue
- Copied and completed code from the [DQD Manual](https://github.com/OHDSI/DataQualityDashboard/raw/main/inst/doc/DataQualityDashboard.pdf), and saved as `/files/scripts/QC/dataqualitydashboard.r`
- Added loading of required R packages

### 6.2.2 Execution

- Run `/files/scripts/QC/dataqualitydashboard.r`
- View dashboard at `127.0.0.1:4891`

## 6.3 Atlas (OHDSI)

### 6.3.1 Installation

- Install Chrome in the Linux VM
- Updated docker-compose
- Installed Broadsea locally as described in the Quick Start from the [Broadsea repository](https://github.com/OHDSI/Broadsea)
- Saved Docker images: `docker save < docker_image_name> > < docker_image_name >.tar`
- Uploaded images to the workspace
- Loaded images into Docker: `cat < docker image name > | docker load`
- Changed in `docker-compose.yml`: traefik: `image: traefik:v.2.9.4` and broadsea-atlasdb: `ports: "5433:5433"`
- Changed in `/etc/default/grub`: `GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"`
- Ran `sudo update-grub`
- Ran `docker-compose --profile default up -d --pull never` (from `Broadsea` directory)
- To view Atlas: `http://127.0.0.1`
- Shutdown Broadsea: `docker-compose down` (from `Broadsea-main` directory)
- CDM Configuration for use with WebAPI: https://github.com/OHDSI/WebAPI/wiki/CDM-Configuration
- Set up results schema as described `sudo -u postgres psql -d omopdb -f /files/scripts/WebAPI/results_schema_setup.sql`
- Created group webapi and login user webapi_sa for omopdb using `PgAdmin III`
- Run `sudo -u postgres psql -d omopdb -f /files/scripts/WebAPI/webapi_permissions.sql`
- Added omopdb details to the WebAPI db `sudo -u postgres psql -h localhost -p 5433 -f /files/scripts/WebAPI/webapidb_omopdb_details.sql`
- WebAPI couldn't talk to the local PostgreSQL db:
    - Changed in the `/etc/postgresql/10/main/pg_hba.conf` file: `127.0.0.1/32` to `0.0.0.0/0`
    - Added to the `/etc/postgresql/10/main/postgresql.conf` file: `listen_addresses = '*'`.
    - Be mindful that these settings will open connections to all IPs, so ideally we should restrict them to Docker internal network.
- Error in logs (`docker logs ohdsi-webapi`) that the column person_count doesn't exist in the achilles_result_concept_count table:
    - Ran `https://github.com/OHDSI/WebAPI/tree/master/src/main/resources/ddl/achilles/achilles_result_concept_count.sql` (had to rewrite some of it to PostgreSQL).

### 6.3.2 Execution

- Run from the Linux VM terminal
```
cd /files/Broadsea/
docker-compose --profile default up -d --pull never
```
- To check whether all Docker containers are up and running: `docker ps` (there should be 6 containers).
- To view Atlas: `http://127.0.0.1/atlas`.


## 6.4 CdmInspection (EHDEN)

### 6.4.1 Installation

- Not in CRAN, and GitHub is not accessible from the workspace, so `remotes::install_github()` cannot be used
- Installed `CdmInspection` and `ROhdsiWebApi`  in local RStudio, zipped folders, uploaded to the workspace, unzipped, and moved to `/usr/local/lib/R/site-library`
- Warning as local R Studio has R version 4.3.1. Doesn't seem to cause any issue
- Installation needed also `officer` package
- Copied and completed code from the [CdmInspection repository](https://github.com/EHDEN/CdmInspection/blob/master/extras/CodeToRun.R), saved as `/files/scripts/QC/cdminspection.r`
- Added loading of required R packages: `benchmarkme` and `flextable`

### 6.4.2 Execution
- Run from the Linux VM terminal: `Rscript /files/scripts/QC/cdminspection.r`.

## 6.5 CatalogueExport (EHDEN)

### 6.5.1 Installation

- Not in CRAN and GitHub is not accessible from the workspace. Installed by downloading the [CatalogueExport repository](https://github.com/EHDEN/CatalogueExport) as a ZIP
- Installed using `devtools::install_local(<ZIP>)`

### 6.5.2. Execution

- Run from the Linux VM terminal: `Rscript /files/scripts/QC/ehden_catalogue_export.r`.





