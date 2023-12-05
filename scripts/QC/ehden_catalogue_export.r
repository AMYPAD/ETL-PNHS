# EHDEN Catalogue Export

## Install library
if (!require("devtools")) install.packages("devtools")

# To install the master branch
#devtools::install_github("EHDEN/CatalogueExport")
#devtools::install_local("/files/downloads/CatalogueExport-master.zip")

# To install latest release (if master branch contains a bug for you)
# devtools::install_github("EHDEN/CatalogueExport@*release")  

# To avoid Java 32 vs 64 issues 
# devtools::install_github("EHDEN/CatalogueExport", args="--no-multiarch")


## Connection
#library(DatabaseConnector)
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = "localhost/omopdb",
  user = "postgres",
  password = "",
  pathToDriver = "/files/jdbcdriver")

## Run CatalogueExport analysis
library(CatalogueExport)

catalogueExport(
  connectionDetails, 
  cdmDatabaseSchema = "cdmdatabaseschema", 
  resultsDatabaseSchema = "results",
  vocabDatabaseSchema = "cdmdatabaseschema",
  numThreads = 1,
  sourceName = "AMYPAD PNHS", 
  cdmVersion = "5.4",
  outputFolder = "/files/output"
  )
