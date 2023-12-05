INSERT INTO cdmdatabaseschema.visit_occurrence
(
    person_id,
    visit_occurrence_id,
    preceding_visit_occurrence_id,
    visit_start_date,
    visit_end_date,
    visit_concept_id,
    visit_type_concept_id
)
SELECT
    -- Fields from PNHS General table
    CAST(REGEXP_REPLACE(amypad_id, '[^0-9]+', '', 'g') AS INT) AS person_id,
    
    visit_id AS visit_occurrence_id,
    prev_visit_id AS preceding_visit_occurrence_id,
    
    '2010-01-01'::DATE + visit_days AS visit_start_date,
    '2010-01-01'::DATE + visit_days AS visit_end_date,
    
    
    
    -- Fixed fields
    32761 AS visit_concept_id,     -- Person Under Investigation
    32809 AS visit_type_concept_id -- Case Report Form

FROM pnhs.omop_visits
;
