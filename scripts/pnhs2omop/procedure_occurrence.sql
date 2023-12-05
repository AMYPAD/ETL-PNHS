
INSERT INTO cdmdatabaseschema.procedure_occurrence
(
    procedure_occurrence_id,
    person_id,
    visit_occurrence_id,
    procedure_concept_id,
    procedure_date,
    procedure_type_concept_id,
    modifier_concept_id,
    modifier_source_value
)
SELECT
    -- PROCEDURE_OCURRENCE_ID
    procedure_id AS procedure_occurrence_id,
    
    -- PERSON_ID
    CAST(REGEXP_REPLACE(amypad_id, '[^0-9]+', '', 'g') AS INT) AS person_id,
    
    -- VISIT_OCURRENCE_ID
    visit_id AS visit_occurrence_id,
    
    -- PROCEDURE_CONCEPT_ID
    CASE procedure
      WHEN 'PET' THEN 2000000121 -- Amyloid PET (AMYPAD)
      WHEN 'MRI' THEN 3023655    -- MR Brain (LOINC)
    END AS procedure_concept_id,

    -- PROCEDURE_DATE 
    '2010-01-01'::DATE + days::INT AS procedure_date,
    
    -- PROCEDURE_TYPE_CONCEPT_ID
    32809 AS procedure_type_concept_id,  -- Case Report Form

    -- MODIFIER_CONCEPT_ID
    CASE procedure
      WHEN 'PET' THEN
        CASE pet_tracer
          WHEN 1 THEN 2000000001 -- Florbetaben
          WHEN 2 THEN 2000000003 -- Flutemetamol
          WHEN 3 THEN 2000000002 -- Florbetapir
          WHEN 4 THEN 2000000007 -- PiB
        END
      WHEN 'MRI' THEN NULL
    END AS modifier_concept_id,
    
    -- MODIFIER_SOURCE_VALUE
    CASE procedure
      WHEN 'PET' THEN pet_tracer
      WHEN 'MRI' THEN NULL
    END AS modifier_source_value

FROM pnhs.omop_procedure
;