INSERT INTO cdmdatabaseschema.cdm_source (
    cdm_source_name,
    cdm_source_abbreviation,
    cdm_holder,
    source_description,
    source_documentation_reference,
    cdm_etl_reference,
    source_release_date,
    cdm_release_date,
    cdm_version,
    cdm_version_concept_id,
    vocabulary_version
) 
SELECT
    'AMYPAD PNHS dataset',
    'AMYPAD PNHS',
    'AMYPAD',
    'The Amyloid Imaging to Prevent Alzheimers Disease (AMYPAD) Prognostic and Natural History Study (PNHS) is an open-label, prospective, multicentre, cohort study linked to a variety of European Parent Cohorts. AMYPAD PNHS aims to improve disease modelling efforts and individualized risk stratification within the context of Alzheimers disease, by the additional collection of amyloid burden, measured by positron emission tomography (PET) imaging.',
    'https://doi.org/10.5281/zenodo.7962885', -- e.g. link to source data dictionary
    'https://github.com/AMYPAD/ETL-PNHS',     -- e.g. link to ETL documentation
    CURRENT_DATE,                             -- when the source data was pulled
    CURRENT_DATE,                             -- or the date of ETL run
    'v5.4',
    756265,                                   -- 'OMOP CDM Version 5.4.0'
    vocabulary_version
    
FROM cdmdatabaseschema.vocabulary 
WHERE vocabulary_id = 'None';