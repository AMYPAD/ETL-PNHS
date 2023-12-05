-- TRUNCATE location CASCADE;

INSERT INTO cdmdatabaseschema.location
(
    location_id,
    county,
    country_concept_id,
    country_source_value
)
SELECT
    site_name AS location_id,
    
    CASE country
      WHEN 1 THEN 'Belgium'
      WHEN 2 THEN 'France'
      WHEN 3 THEN 'Germany'
      WHEN 4 THEN 'Netherlands'
      WHEN 5 THEN 'Spain'
      WHEN 6 THEN 'Sweden'
      WHEN 7 THEN 'Switzerland'
      WHEN 8 THEN 'UK'
      WHEN 9 THEN 'Italy'
      WHEN 10 THEN 'Greece'
    END AS country,
    
    CASE country
      WHEN 1 THEN 41890291
      WHEN 2 THEN 41928898
      WHEN 3 THEN 41970930
      WHEN 4 THEN 42032171
      WHEN 5 THEN 42020824
      WHEN 6 THEN 42030997
      WHEN 7 THEN 42057336
      WHEN 8 THEN 42035286
      WHEN 9 THEN 41987173
      WHEN 10 THEN 4330430 -- SNOMED ID since 'Greece' is not in OSM Geography
    END AS country_concept_id,
    
    country AS country_source_value

FROM pnhs.omop_location
;