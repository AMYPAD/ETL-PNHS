library(shiny)

# Connection details ----
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  user = "postgres",
  password = "",
  server = "localhost/omopdb",
  port = "5432",
  extraSettings = "",
  pathToDriver = "/files/jdbcdriver"
)


cdmDatabaseSchema <- "cdmdatabaseschema" # the fully qualified database schema name of the CDM
resultsDatabaseSchema <- "results" # the fully qualified database schema name of the results schema (that you can write to)
cdmSourceName <- "AMYPAD PNHS" # a human readable name for your CDM source
cdmVersion <- "5.4" # the CDM version you are targetting. Currently supports 5.2, 5.3, and 5.4

# determine how many threads (concurrent SQL sessions) to use
numThreads <- 1 # on Redshift, 3 seems to work well

# specify if you want to execute the queries or inspect them
sqlOnly <- FALSE                  # set to TRUE if you just want to get the SQL scripts and not actually run the queries
sqlOnlyIncrementalInsert <- FALSE # set to TRUE if you want the generated SQL queries to calculate DQD results and insert them into a database table (@resultsDatabaseSchema.@writeTableName)
sqlOnlyUnionCount <- 1            # in sqlOnlyIncrementalInsert mode, the number of check sqls to union in a single query; higher numbers can improve performance in some DBMS (e.g. a value of 25 may be 25x faster)

# NOTES specific to sqlOnly <- TRUE option
# 1. You do not need a live database connection. Instead, connectionDetails only needs these parameters:
# connectionDetails <- DatabaseConnector::createConnectionDetails(
# dbms = "", # specify your dbms
# pathToDriver = "/"
# )
# 2. Since these are fully functional queries, this can help with debugging.
# 3. In the results output by the sqlOnlyIncrementalInsert queries, placeholders are populated for execution_time, query_text, and warnings/errors; and the NOT_APPLICABLE rules are not applied.
# 4. In order to use the generated SQL to insert metadata and check results into output table, you must set sqlOnlyIncrementalInsert = TRUE. Otherwise sqlOnly is backwards compatable with <= v2.2.0, generating queries which run the checks but don't store the results.

# Results ----
## where should the results and logs go?
outputFolder <- "/files/output"
outputFile <- "results.json"

## logging type
verboseMode <- TRUE # set to FALSE if you don't want the logs to be printed to the console

## write results to table?
writeToTable <- TRUE # set to FALSE if you want to skip writing to a SQL table in the results schema

## specify the name of the results table (used when writeToTable = TRUE and when sqlOnlyIncrementalInsert = TRUE)
writeTableName <- "dqdashboard_results"

## write results to a csv file?
writeToCsv <- TRUE              # set to FALSE if you want to skip writing to csv file
csvFile <- "dqdashboard_results.csv" # only needed if writeToCsv is set to TRUE

# if writing to table and using Redshift, bulk loading can be initialized
# Sys.setenv("AWS_ACCESS_KEY_ID" = "",
# "AWS_SECRET_ACCESS_KEY" = "",
# "AWS_DEFAULT_REGION" = "",
# "AWS_BUCKET_NAME" = "",
# "AWS_OBJECT_KEY" = "",
# "AWS_SSE_TYPE" = "AES256",
# "USE_MPP_BULK_LOAD" = TRUE)

# DQ Settings: ----

## which DQ check levels to run
checkLevels <- c("TABLE", "FIELD", "CONCEPT")

# which DQ checks to run?
checkNames <- c() # Names can be found in inst/csv/OMOP_CDM_v5.3_Check_Descriptions.csv

# which CDM tables to exclude?
tablesToExclude <- c("CONCEPT", "VOCABULARY", "CONCEPT_ANCESTOR", "CONCEPT_RELATIONSHIP", "CONCEPT_CLASS", "CONCEPT_SYNONYM", "RELATIONSHIP", "DOMAIN") # list of CDM table names to skip evaluating checks against; by default DQD excludes the vocab tables

# Run the job ----
DataQualityDashboard::executeDqChecks(connectionDetails = connectionDetails,
                                      cdmDatabaseSchema = cdmDatabaseSchema,
                                      resultsDatabaseSchema = resultsDatabaseSchema,
                                      cdmSourceName = cdmSourceName,
                                      cdmVersion = cdmVersion,
                                      numThreads = numThreads,
                                      sqlOnly = sqlOnly,
                                      sqlOnlyUnionCount = sqlOnlyUnionCount,
                                      sqlOnlyIncrementalInsert = sqlOnlyIncrementalInsert,
                                      outputFolder = outputFolder,
                                      verboseMode = verboseMode,
                                      writeToTable = writeToTable,
                                      writeToCsv = writeToCsv,
                                      csvFile = csvFile,
                                      checkLevels = checkLevels,
                                      tablesToExclude = tablesToExclude,
                                      checkNames = checkNames)
# Inspect logs ----
ParallelLogger::launchLogViewer(logFileName = file.path(outputFolder, sprintf("log_DqDashboard_%s.txt", cdmSourceName)))

# View dqDashboard
json <- list.files(path = "/files/output", pattern = ".json", full.names = TRUE)
DataQualityDashboard::viewDqDashboard(dplyr::last(json))

# (OPTIONAL) if you want to write the JSON file to the results table separately -----------------------------
#jsonFilePath <- ""
#DataQualityDashboard::writeJsonResultsToTable(connectionDetails = connectionDetails,
#resultsDatabaseSchema = resultsDatabaseSchema,
#jsonFilePath = jsonFilePath)