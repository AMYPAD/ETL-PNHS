
INSERT INTO cdmdatabaseschema.measurement
(
    measurement_id,
    person_id,
    visit_occurrence_id,
    measurement_concept_id,
    measurement_date,
    measurement_type_concept_id,
    value_as_number,
    value_as_concept_id,
    unit_concept_id,
    value_source_value
)
SELECT
    -- MEASUREMENT_ID
    measurement_id AS measurement_id,
    
    -- PERSON_ID
    CAST(REGEXP_REPLACE(amypad_id, '[^0-9]+', '', 'g') AS INT) AS person_id,
    
    -- VISIT_OCURRENCE_ID
    visit_id AS visit_occurrence_id,
    
    -- CONCEPT_ID
    CASE name
      -- Genetics
      WHEN 'apoe_genotype' THEN 35953767      -- APOE (apolipoprotein E) gene variant measurement (OMOP Genomic)
      
      -- Vitals
      WHEN 'heart_rate' THEN 40481601         -- Resting heart rate (SNOMED)
      WHEN 'bp_systolic' THEN 4152194         -- Systolic blood pressure (SNOMED)
      WHEN 'bp_diastolic' THEN 4154790        -- Diastolic blood pressure (SNOMED)
      WHEN 'circumference_waist' THEN 4172830 -- Waist circumference (SNOMED) 
      WHEN 'circumference_hip' THEN 4111665   -- Hip circumference (SNOMED) 
      WHEN 'weight' THEN 4099154              -- Body weight (SNOMED) 
      WHEN 'height' THEN 607590               -- Body height (SNOMED) 
      WHEN 'bmi' THEN 4245997                 -- Body mass index (SNOMED) 
      WHEN 'whtr' THEN  44809433              -- Waist to height ratio (SNOMED)
      
      -- Medical History
      WHEN 'mh_frs' THEN 42872767	            -- Framingham coronary heart disease 10 year risk score (SNOMED)
      
      -- Lifestyle
      WHEN 'physical_met' THEN 44782837	      -- Metabolic equivalent of task (SNOMED)
      
      -- Neuropsychiatric
      WHEN 'depression_zrefpc' THEN 2000000018 -- Depression [Z-score] (AMYPAD)
      WHEN 'anxiety_zrefpc' THEN 2000000013	   -- Anxiety [Z-score] (AMYPAD)
      
      -- Neuropsychological
      WHEN 'iadl_zrefpc' THEN 2000000022               -- Instrumental activities of daily living [Z-score] (AMYPAD)
      WHEN 'memory_ir_zrefpc' THEN 2000000026          -- Memory: Immediate recall [Z-score] (AMYPAD)
      WHEN 'memory_dr_zrefpc' THEN 2000000025          -- Memory: Delayed recall [Z-score] (AMYPAD)
      WHEN 'memory_recognition_zrefpc' THEN 2000000027 -- Memory: Recognition [Z-score] (AMYPAD)
      WHEN 'memory_visual_zrefpc' THEN 2000000028      -- Memory: Visual [Z-score] (AMYPAD)
      WHEN 'language_fluency_zrefpc' THEN 2000000023   -- Language: Fluency [Z-score] (AMYPAD)
      WHEN 'language_naming_zrefpc' THEN 2000000024    -- Language: Naming [Z-score] (AMYPAD)
      WHEN 'attention_dsf_zrefpc' THEN 2000000016      -- Attention: Digit span forward [Z-score] (AMYPAD)
      WHEN 'attention_dsb_zrefpc' THEN 2000000015      -- Attention: Digit span backwards [Z-score] (AMYPAD)
      WHEN 'attention_coding_zrefpc' THEN 2000000014   -- Attention: Coding [Z-score] (AMYPAD)
      WHEN 'attention_tmta_zrefpc' THEN 2000000017     -- Attention: Trail Making Test (Part A) [Z-score] (AMYPAD)
      WHEN 'executive_tmtb_zrefpc' THEN 2000000021     -- Executive: Trail Making Test (Part B) [Z-score] (AMYPAD)
      WHEN 'executive_tmtba_zrefpc' THEN 2000000020    -- Executive: Trail Making Test (B/A ratio) [Z-score] (AMYPAD)
      WHEN 'executive_letter_zrefpc' THEN 2000000019   -- Executive: Letter Fluency [Z-score] (AMYPAD)
      WHEN 'visuospatial_zrefpc' THEN 2000000033       -- Visuospatial Functioning [Z-score] (AMYPAD)
      
      -- CSF
      WHEN 'csf_abeta42' THEN 3042810         -- Amyloid beta 42 peptide [Mass/volume] in Cerebral spinal fluid (LOINC)
      WHEN 'csf_abeta40' THEN 42868555        -- Amyloid beta 40 peptide [Mass/volume] in Cerebral spinal fluid (LOINC)
      WHEN 'csf_abeta42_40' THEN 1617024      -- Amyloid beta 42 peptide/Amyloid beta 40 peptide [Mass Ratio] in Cerebral spinal fluid (LOINC)
      WHEN 'csf_ptau' THEN 43055225           -- Phosphorylated tau 181 [Mass/volume] in Cerebral spinal fluid by Immunoassay (LOINC)
      WHEN 'csf_ttau' THEN 3000242            -- Tau protein [Mass/volume] in Cerebral spinal fluid (LOINC)
      WHEN 'csf_abeta_zrefpc' THEN 2000000008 -- Amyloid beta peptide in Cerebral spinal fluid [Z-score] (AMYPAD)
      WHEN 'csf_ptau_zrefpc' THEN 2000000031  -- Phosphorylated tau 181 in Cerebral spinal fluid [Z-score] (AMYPAD)
      WHEN 'csf_ttau_zrefpc' THEN 2000000032  -- Tau protein in Cerebral spinal fluid [Z-score] (AMYPAD)
      
      -- PET
      WHEN 'pet_suvr_refwc_gca_gaain' THEN 2000000012 -- Amyloid SUVR GCA (AMYPAD)
      WHEN 'pet_cl_refwc_gca_gaain' THEN 2000000009   -- Amyloid CL GCA (AMYPAD)
      WHEN 'pet_srtm2_dvr_gca_gaain' THEN 2000000010  -- Amyloid DVR GCA (AMYPAD)
      WHEN 'pet_srtm2_r1_gca_gaain' THEN 2000000011   -- Amyloid R1 GCA (AMYPAD)

    END AS measurement_concept_id,
    
    -- MEASUREMENT_DATE
    '2010-01-01'::DATE + days::INT AS measurement_date,
    
    -- MEASUREMENT_TYPE_CONCEPT_ID
    32809 AS measurement_type_concept_id, -- Case Report Form
    
    -- VALUE_AS_NUMBER
    as_number AS value_as_number,
    
    -- VALUE_AS_CONCEPT
    CASE name
      -- Genetics
      WHEN 'apoe_genotype' THEN
        CASE as_concept
          WHEN 1 THEN 36307526 -- (e2e2)
          WHEN 2 THEN 36310377 -- (e2e3)
          WHEN 3 THEN 36308156 -- (e2e4)
          WHEN 4 THEN 36309003 -- (e3e3)
          WHEN 5 THEN 36311054 -- (e3e4)
          WHEN 6 THEN 36303222 -- (e4e4)
        END
      
      -- Vitals
      WHEN 'bmi' THEN
        CASE as_concept
          WHEN 1 THEN 763938    -- (Below normal)
          WHEN 2 THEN 45884153  -- (Normal)
          WHEN 3 THEN 1990036   -- (Overweight)
          WHEN 4 THEN 45877450  -- (Obesity)  
        END

      END AS value_as_concept_id,
    
    -- UNIT_CONCEPT_ID
    CASE name
      -- Vitals
      WHEN 'heart_rate' THEN 8541          -- per minute (UCUM)
      WHEN 'bp_systolic' THEN 8876         -- milimeter mercury columm (UCUM)
      WHEN 'bp_diastolic' THEN 8876        -- milimeter mercury columm (UCUM)
      WHEN 'circumference_waist' THEN 8582 -- centimeter (UCUM)
      WHEN 'circumference_hip' THEN 8582   -- centimeter (UCUM)
      WHEN 'weight' THEN 9529              -- kilogram (UCUM)
      WHEN 'height' THEN 9529              -- kilogram (UCUM)
      WHEN 'bmi' THEN 9531                 -- kilogram per square meter (UCUM) 
      WHEN 'whtr' THEN 8523                -- ratio (UCUM)
      
      -- Lifestyle
      WHEN 'physical_met' THEN	9360 -- metabolic equivalent (UCUM)
      
      -- Neuropsychiatric
      WHEN 'depression_zrefpc' THEN 32912 -- Generic unit for indivisible thing (UCUM)
      WHEN 'anxiety_zrefpc' THEN 32912    -- Generic unit for indivisible thing (UCUM)
      
      -- Neuropsychological
      WHEN 'iadl_zrefpc' THEN 32912               -- Generic unit for indivisible thing (UCUM)
      WHEN 'memory_ir_zrefpc' THEN 32912          -- Generic unit for indivisible thing (UCUM)
      WHEN 'memory_dr_zrefpc' THEN 32912          -- Generic unit for indivisible thing (UCUM)
      WHEN 'memory_recognition_zrefpc' THEN 32912 -- Generic unit for indivisible thing (UCUM)
      WHEN 'memory_visual_zrefpc' THEN 32912      -- Generic unit for indivisible thing (UCUM)
      WHEN 'language_fluency_zrefpc' THEN 32912   -- Generic unit for indivisible thing (UCUM)
      WHEN 'language_naming_zrefpc' THEN 32912    -- Generic unit for indivisible thing (UCUM)
      WHEN 'attention_dsf_zrefpc' THEN 32912      -- Generic unit for indivisible thing (UCUM)
      WHEN 'attention_dsb_zrefpc' THEN 32912      -- Generic unit for indivisible thing (UCUM)
      WHEN 'attention_coding_zrefpc' THEN 32912   -- Generic unit for indivisible thing (UCUM)
      WHEN 'attention_tmta_zrefpc' THEN 32912     -- Generic unit for indivisible thing (UCUM)
      WHEN 'executive_tmtb_zrefpc' THEN 32912     -- Generic unit for indivisible thing (UCUM)
      WHEN 'executive_tmtba_zrefpc' THEN 32912    -- Generic unit for indivisible thing (UCUM)
      WHEN 'executive_letter_zrefpc' THEN 32912   -- Generic unit for indivisible thing (UCUM)
      WHEN 'visuospatial_zrefpc' THEN 32912       -- Generic unit for indivisible thing (UCUM)
      
      -- CSF
      WHEN 'csf_abeta42' THEN 8845       -- picogram per milliliter (UCUM)
      WHEN 'csf_abeta' THEN 408845       -- picogram per milliliter (UCUM)
      WHEN 'csf_abeta42_40' THEN 32912   -- Generic unit for indivisible thing (UCUM)
      WHEN 'csf_ptau'	THEN 8845          -- picogram per milliliter (UCUM)
      WHEN 'csf_ttau'	THEN 8845          -- picogram per milliliter (UCUM)
      WHEN 'csf_abeta_zrefpc' THEN 32912 -- Generic unit for indivisible thing (UCUM)
      WHEN 'csf_ptau_zrefpc' THEN 32912  -- Generic unit for indivisible thing (UCUM)
      WHEN 'csf_ttau_zrefpc' THEN 32912  -- Generic unit for indivisible thing (UCUM)

      -- PET
      WHEN 'pet_suvr_refwc_gca_gaain' THEN 32912    -- Generic unit for indivisible thing (UCUM)
      WHEN 'pet_cl_refwc_gca_gaain' THEN 2000000123 -- Centiloid unit (AMYPAD)
      WHEN 'pet_srtm2_dvr_gca_gaain' THEN 8541      -- per minute (UCUM)
      WHEN 'pet_srtm2_r1_gca_gaain' THEN 32912      -- Generic unit for indivisible thing (UCUM)

    END AS unit_concept_id,

    as_number AS value_source_value

FROM pnhs.omop_measurement

;