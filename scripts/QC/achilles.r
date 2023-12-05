#library(DatabaseConnector)
#library(Achilles)

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = "localhost/omopdb",
  user = "postgres",
  password = "",
  pathToDriver = "/files/jdbcdriver"
  )

options(connectionObserver = NULL)
    
Achilles::achilles(connectionDetails = connectionDetails,
    cdmDatabaseSchema = "cdmdatabaseschema",
    resultsDatabaseSchema = "results",
    #createTable = TRUE,
    outputFolder = "/files/output",
    optimizeAtlasCache = TRUE)
