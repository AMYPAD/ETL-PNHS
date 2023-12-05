INSERT INTO cdmdatabaseschema.person
(
    person_id,
    person_source_value,
    year_of_birth,
    location_id,
    gender_concept_id,
    gender_source_value,
    race_concept_id,
    race_source_value,
    ethnicity_concept_id
)
SELECT
    -- fields from PNHS_GENERAL
    CAST(REGEXP_REPLACE(amypad_id, '[^0-9]+', '', 'g') AS INT) AS person_id,
    amypad_id AS person_source_value,
    (2010 - baseline_age) AS year_of_birth,
    site_name AS location_id,
    
    
    -- fields from PNHS_DEMO
    CASE sex
      WHEN 1 THEN 8507 -- Male
      WHEN 2 THEN 8532 -- Female
      WHEN 3 THEN 8521 -- Other (Non-Standard & Invalid)
    END AS gender_concept_id,
    sex AS gender_source_value,

    CASE ethnic
      WHEN 1 THEN 8527         -- Caucasian
      WHEN 2 THEN 8515         -- Asian
      WHEN 3 THEN 38003598     -- Black
      WHEN 4 THEN 38003616     -- Arab
      ELSE 8527                -- European (IMPROVE!)
      --WHEN ethnic = 5 THEN 45483082     -- Other
      --WHEN ethnic IS NULL THEN 45877986 -- Unknown
    END AS race_concept_id,
    
    ethnic AS race_source_value,
    
    -- OMOP Ethnicity not applicable for cohort
    0 AS ethnicity_concept_id
    
FROM pnhs.omop_person
;
