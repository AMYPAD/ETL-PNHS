# *******************************************************
# -----------------INSTRUCTIONS -------------------------
# *******************************************************
#
#-----------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------
# This CodeToRun.R is provided as an example of how to run this package.
# Below you will find 2 sections: the 1st is for installing the dependencies
# required to run the package and the 2nd for running the package.
#
# The code below makes use of R environment variables (denoted by "Sys.getenv(<setting>)") to
# allow for protection of sensitive information. If you'd like to use R environment variables stored
# in an external file, this can be done by creating an .Renviron file in the root of the folder
# where you have cloned this code. For more information on setting environment variables please refer to:
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/readRenviron.html
#
# Below is an example .Renviron file's contents.
# Remove the "#" below as these too are interpreted as comments in the .Renviron file.
#
#    DBMS = "postgresql"
#    DB_SERVER = "database.server.com"
#    DB_PORT = 5432
#    DB_USER = "database_user_name_goes_here"
#    DB_PASSWORD = "your_secret_password"
#    PATH_TO_DRIVER = "C:/path_to_jdbc_driver"
#
# The following describes the settings
#    DBMS, DB_SERVER, DB_PORT, DB_USER, DB_PASSWORD := These are the details used to connect
#    to your database server. For more information on how these are set, please refer to:
#    http://ohdsi.github.io/DatabaseConnector/
#
# Once you have established an .Renviron file, you must restart your R session for R to pick up these new
# variables.
#
# In section 2 below, you will also need to update the code to use your site specific values. Please scroll
# down for specific instructions.
#-----------------------------------------------------------------------------------------------
#
#
# *******************************************************
# SECTION 1: Make sure to install all dependencies (not needed if already done) -------------------------------
# *******************************************************
#
# Prevents errors due to packages being built for other R versions:
Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = TRUE)
#
# First, it probably is best to make sure you are up-to-date on all existing packages.
# Important: This code is best run in R, not RStudio, as RStudio may have some libraries
# (like 'rlang') in use.
#update.packages(ask = "graphics")

# When asked to update packages, select '1' ('update all') (could be multiple times)
# When asked whether to install from source, select 'No' (could be multiple times)
#install.packages("devtools")
#devtools::install_github("EHDEN/CdmInspection.R")

# *******************************************************
# SECTION 2: Set Local Details
# *******************************************************
library(CdmInspection)
library(benchmarkme)
library(flextable)

# Details for connecting to the server:
dbms <- "postgresql"
user <- "postgres"
password <- ""
server <- "localhost/omopdb"
port <- "5432"
pathToDriver <- "/files/jdbcdriver"

# connectionString is optional
# if specified, the server, port fields are ignored. If user and password are not specified, they are assumed to already be included in the connection string.
connectionString = if (Sys.getenv("CONNECTION_STRING") == "") NULL else Sys.getenv("CONNECTION_STRING")

# Author details
authors <-"David Vallez Garcia, Bert Overduin" # used on the title page

# Details specific to the database:
databaseId <- "AMYPAD" # for example SYNPUF (this will be used as results sub-folder)
databaseName <- "AMYPAD PNHS Dataset"
databaseDescription <- "The Amyloid Imaging to Prevent Alzheimers Disease (AMYPAD) Prognostic and Natural History Study (PNHS) is an open-label, prospective, multicentre, cohort study linked to a variety of European Parent Cohorts. AMYPAD PNHS aims to improve disease modelling efforts and individualized risk stratification within the context of Alzheimers disease, by the additional collection of amyloid burden, measured by positron emission tomography (PET) imaging."

# For Oracle: define a schema that can be used to emulate temp tables:
oracleTempSchema <- NULL

# Details for connecting to the CDM and storing the results
#outputFolder <- file.path(getwd(), "results",databaseId)
outputFolder <- "/files/output"
cdmDatabaseSchema <- "cdmdatabaseschema"
resultsDatabaseSchema <- "results" # Make sure the Achilles results are in this schema!
vocabDatabaseSchema <- "cdmdatabaseschema"

# Url to check the version of your local Atlas
baseUrl <- "" # example: "http://atlas.your.organisation.com/WebAPI"

# All results smaller than this value are removed from the results.
smallCellCount <- 5

verboseMode <- TRUE

# *******************************************************
# SECTION 3: Run the package
# *******************************************************

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                #port = port,
                                                                user = user,
                                                                password = password,                                                                
                                                                #connectionString = connectionString,
                                                                pathToDriver = pathToDriver)



results <- cdmInspection(
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = cdmDatabaseSchema,
  resultsDatabaseSchema = resultsDatabaseSchema,
  vocabDatabaseSchema = vocabDatabaseSchema,
  oracleTempSchema = oracleTempSchema,
  databaseId = databaseId,
  databaseName = databaseName,
  databaseDescription = databaseDescription,
  runVocabularyChecks = TRUE,
  runDataTablesChecks = TRUE,
  runPerformanceChecks = TRUE,
  runWebAPIChecks = TRUE,
  smallCellCount = smallCellCount,
  baseUrl = baseUrl,
  sqlOnly = FALSE,
  outputFolder = outputFolder,
  verboseMode = verboseMode
)

generateResultsDocument(
  results,
  outputFolder,
  authors = authors,
  databaseId = databaseId,
  databaseName = databaseName,
  databaseDescription = databaseDescription,
  smallCellCount = smallCellCount
)
