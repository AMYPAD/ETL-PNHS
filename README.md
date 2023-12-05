# AMYPAD PNHS: ETL for OMOP CDM

The goal of this repository is to provide access to the documentation and the scripts used to performed the Extraction Transform, and Load (ETL) process to move the AMYPAD PNHS dataset into the [OMOP CDM](https://ohdsi.github.io/CommonDataModel/).

## General Information

*Database fullname:* The Amyloid Imaging to Prevent Alzheimer’s Disease (AMYPAD) Prognostic and Natural History Study (PNHS)
*Database acronym:* AMYPAD PNHS
*Database source:* [AMYPAD PNHS - Integrated dataset (Raw) v202306](https://zenodo.org/doi/10.5281/zenodo.8017083)
*Contact:* [amypad.pnhs\@amsterdamumc.nl](mailto:amypad.pnhs@amsterdamumc.nl?subject=OMOP_CDM)
*Website:* [amypad.eu](https://amypad.eu/project/amypad-pnhs/)
*ETL developed:* by [Stichting VUMC](https://www.vumc.nl/) in collaboration with [Aridhia Informatics Ltd.](https://www.aridhia.com/)

## Database description

The Amyloid Imaging to Prevent Alzheimer’s Disease (AMYPAD) Prognostic and Natural History Study (PNHS) is an open-label, prospective, multicentre, cohort study linked to a variety of European Parent Cohorts.

[AMYPAD PNHS](https://amypad.eu/project/amypad-pnhs/) aims to improve disease modelling efforts and individualized risk stratification within the context of Alzheimer's disease, by the additional collection of amyloid burden, measured by positron emission tomography (PET) imaging.

The current version of the AMYPAD PNHS dataset [v202306](https://zenodo.org/doi/10.5281/zenodo.8017083) integrates information from 10 Parent Cohorts: [ALFA+](https://www.barcelonabeta.org/en/alzheimer-research/studies/alfa-study), [AMYPAD DPMS](https://amypad.eu/project/dpms/), [DELCODE](https://www.dzne.de/en/research/studies/clinical-studies/delcode/), [EMIF-AD](http://www.emif.eu/emif-ad-2/) (60++ and 90+), [EPAD LCS](https://ep-ad.org/), [FACEHBI](https://www.fundacioace.com/en/facehbi.html), F-PACK, Microbiota, and UCL-2010-412. This dataset includes a total of 3368 participants. Of them, 1620 underwent a baseline amyloid PET that includes the visual read and the Centiloid quantification (1476 subjects), among other metrics. Moreover, 888 participants have (at least) one follow-up PET scan, 763 of them with Centiloid quantification. The participant's clinical outcomes (e.g., cognition), disease (imaging) biomarkers, risk factors (e.g., genetics and environmental), and other relevant variables are included in the dataset.

The latest version of the dataset [v202306](https://zenodo.org/doi/10.5281/zenodo.8017083) has been partially mapped to the OMOP CDM 5.4

## ETL Implementation

Implementation of the ETL was done using two programming languages languages:
- *R*. It was used for preparation of the data (source to staging) and to run the CDM quality control and inspection tools (i.e. Achilles, DataQualityDashboard, ATLAS, CdmInspection, and CatalogueExport).
- *PostgreSQL*. It was used to handle the databases (e.g. staging to CDM)

Within the `scripts` folder, a README.md document describes the steps followed in the transformation of the source data to the OMOP CDM. This document includes:
1.	Setup of the database and connections
2.	Vocabulary setup
3.	Adjustment of the original OMOP CDM SQL files
4.	Preprocess of AMYPAD PNHS data
5.	Create OMOP CDM schema and populate with AMYPAD PNHS data
6.	Quality Control

The scripts are stored in separated sub-folders:
- `CDM` Contains the SQL code used to setup the database, including the CSV files used in the vocabulary
- `pnhs2omop` This folder contain 3 sets of scripts:
	- `update_vocabularies.R` is used to update the standard vocabulary CSV files with the specific information from the AMYPAD PNHS vocabulary
	- `preprocess_pnhs.R` is used to transform the source database into the staging tables
	- `master_script.sh` creates the OMOP CDM tables and uploads the AMYPAD PNHS data
	- `*.sql` scrtips are used by `master_script.sh` to create populated each of the target tables (staging to OMOP CDM).
- `QC` Includes all the code used in R to run the quality control
	- `achilles.r` [OHDSI Achilles](https://github.com/OHDSI/Achilles)
	- `dataqualitydashboard.r` [OHDSI DataQualityDashboard](https://github.com/OHDSI/DataQualityDashboard)
	- `cdminspection.r` [EHDEN CdmInspection](https://github.com/EHDEN/CdmInspection)
	- `ehden_catalogue_export.r` [EHDEN CatalogueExport](https://github.com/EHDEN/CatalogueExport)
	- `cohort_vr.sql` Definition of a testing cohort using [OHDSI Atlas](https://github.com/OHDSI/Atlas)
-	WebAPI. Specific scripts used during the setup of the [OHDSI WebAPI](https://github.com/OHDSI/WebAPI)

