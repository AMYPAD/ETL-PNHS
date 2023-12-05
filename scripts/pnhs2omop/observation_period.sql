
INSERT INTO cdmdatabaseschema.observation_period
(
  observation_period_id,
  person_id,
  observation_period_start_date,
  observation_period_end_date,
  period_type_concept_id

)
SELECT

  observation_id AS observation_period_id,
  CAST(REGEXP_REPLACE(amypad_id, '[^0-9]+', '', 'g') AS INT) AS person_id,
  '2010-01-01'::DATE + start_days AS observation_period_start_date,
  '2010-01-01'::DATE + end_days AS observation_period_end_date,
  32809 AS period_type_concept_id -- Case Report Form

FROM pnhs.omop_observation_period
;
