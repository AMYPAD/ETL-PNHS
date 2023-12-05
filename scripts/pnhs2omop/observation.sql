
INSERT INTO cdmdatabaseschema.observation
(
    observation_id,
    person_id,
    visit_occurrence_id,
    observation_concept_id,
    observation_date,
    observation_type_concept_id,
    value_as_number,
    value_as_string,
    value_as_concept_id,
    qualifier_concept_id,
    unit_concept_id,
    qualifier_source_value,
    value_source_value
)
SELECT
    -- OBSERVATION_ID
    observation_id AS observation_id,
    
    -- PERSON_ID
    CAST(REGEXP_REPLACE(amypad_id, '[^0-9]+', '', 'g') AS INT) AS person_id,
    
    -- VISIT_OCURRENCE_ID
    visit_id AS visit_occurrence_id,
    
    -- OBSERVATION_CONCEPT_ID
    CASE name
      -- General
      WHEN 'family_id' THEN 2000000034   -- Family ID (AMYPAD)
      WHEN 'fam_mem_id' THEN 2000000035  -- Family Member ID (AMYPAD)
      WHEN 'cohort_name' THEN 2000000036 -- Parent Cohort (AMYPAD)
      
      -- Demographics
      WHEN 'marital_status' THEN 4053609      -- Marital Status (SNOMED)
      WHEN 'cohabitation_status' THEN 4242253 -- Cohabiting (SNOMED)
      WHEN 'education_years' THEN 4171617     -- Details of education (SNOMED)
      WHEN 'handedness' THEN 4211853          -- Handedness (SNOMED)
      
      -- Family History
      WHEN 'relative_dementia' THEN 2000000038 -- Parental history of dementia (AMYPAD)
      
      -- Medical History
      WHEN 'mh_med_hbp' THEN 40761399      -- Medication taken for high blood pressure (LOINC)
      WHEN 'mh_cva' THEN 3046835           -- Cerebrovascular accident (LOINC)
      WHEN 'mh_diabetes_type' THEN 4236883 -- Diabetes type (SNOMED)
      WHEN 'mh_diabetes' THEN 3046193      -- Diabetes mellitus [Minimum Data Set] (LOINC)
      WHEN 'mh_hbp' THEN 3045668           -- Hypertension [Minimum Data Set] (LOINC)
      WHEN 'mh_hyperchol' THEN 36304348    -- History of Hyperlipidemia (LOINC)
      WHEN 'mh_mi' THEN 40769284           -- Myocardial infarction [Reported] (LOINC)
      WHEN 'mh_chd' THEN 3046106           -- Arteriosclerotic heart disease (LOINC)
      WHEN 'mh_cold' THEN 3044760          -- Emphysema or COPD [Minimum Data Set] (LOINC)
      WHEN 'mh_depression' THEN 3045250    -- Depression [Minimum Data Set] (LOINC)
      WHEN 'mh_ra' THEN 3047327            -- Arthritis [Minimum Data Set] (LOINC)
      WHEN 'mh_cancer' THEN 3042881        -- Cancer [Minimum Data Set] (LOINC)
      WHEN 'mh_head_injury' THEN 3046533   -- Traumatic brain injury [Minimum Data Set] (LOINC)
      
      -- Lifestyle
      WHEN 'tobacco_history' THEN 3012697    -- History of Tobacco use (LOINC)
      WHEN 'tobacco_units' THEN 903652       -- Findings of tobacco or its derivatives use or exposure (OMOP Extension)
      WHEN 'alcohol_history' THEN 3027199    -- History of Alcohol use (LOINC)
      WHEN 'alcohol_units' THEN 35609491     -- Alcohol units consumed per week (SNOMED)
      WHEN 'physical' THEN 2000000108        -- Physical activity [score] (AMYPAD)
      WHEN 'cognitive' THEN 2000000091       -- Cognitive activity [score] (AMYPAD)
      WHEN 'social' THEN 2000000110          -- Social acitivity [score] (AMYPAD)
      WHEN 'sleep' THEN 2000000109           -- Sleep [score] (AMYPAD)
      WHEN 'sleep_dicho' THEN 4086501        -- Quality of sleep (SNOMED)
      WHEN 'diet' THEN 2000000093            -- Diet [score] (AMYPAD)
      WHEN 'diet_cat' THEN 2000000037        -- Adherence to Mediterranean diet (AMYPAD)

      -- Neuropsychological
      WHEN 'cdr_glb' THEN 42869843              -- Clinical Dementia Rating scale [CDR] (LOINC)
      WHEN 'mmse' THEN 42869861                 -- Mini-Mental State Examination [MMSE] (LOINC)
      WHEN 'mmse_dicho' THEN 2000000118         -- Mini-Mental State Examination [status] (AMYPAD)
      WHEN 'iadl' THEN 2000000099               -- IADL [score] (AMYPAD)
      WHEN 'iadl_dicho' THEN 2000000117         -- IADL [status] (AMYPAD)
      WHEN 'memory_ir' THEN 2000000104          -- Memory: Immediate recall [score] (AMYPAD)
      WHEN 'memory_dr' THEN 2000000103          -- Memory: Delayed recall [score] (AMYPAD)
      WHEN 'memory_recognition' THEN 2000000105 -- Memory: Recognition [score] (AMYPAD)
      WHEN 'memory_visual' THEN 2000000106      -- Memory: Visual [score] (AMYPAD)
      WHEN 'language_fluency' THEN 2000000100   -- Language: Fluency [score] (AMYPAD)
      WHEN 'language_naming' THEN 2000000101    -- Language: Naming [score] (AMYPAD)
      WHEN 'attention_dsf' THEN 2000000089      -- Attention: Digit span forward [score] (AMYPAD)
      WHEN 'attention_dsb' THEN 2000000088      -- Attention: Digit span back [score] (AMYPAD)
      WHEN 'attention_coding' THEN 2000000087   -- Attention: Coding [score] (AMYPAD)
      WHEN 'attention_tmta' THEN 2000000090     -- Attention: Trail Making Test (Part A) (AMYPAD)
      WHEN 'executive_tmtb' THEN 2000000096     -- Executive: Trail Making Test (Part B) (AMYPAD)
      WHEN 'executive_tmtba' THEN 2000000095    -- Executive: Trail Making Test (B/A ratio) (AMYPAD)
      WHEN 'executive_letter' THEN 2000000094   -- Executive: Letter Fluency [score] (AMYPAD)
      WHEN 'visuospatial' THEN 2000000111       -- Visuospatial Functioning [score] (AMYPAD)
      
      -- Neuropsychiatric
      WHEN 'depression' THEN 2000000092       -- Depression [score] (AMYPAD)
      WHEN 'depression_dicho' THEN 2000000116 -- Depression [status] (AMYPAD)
      WHEN 'anxiety' THEN 2000000086          -- Anxiety [score] (AMYPAD)
      WHEN 'anxiety_dicho' THEN 2000000115    -- Anxiety [status] (AMYPAD)
      
      -- CSF
      WHEN 'csf_ptau_dicho' THEN 2000000119  -- Phosphorylated tau 181 in CSF [status] (AMYPAD)
      WHEN 'csf_ttau_dicho' THEN 2000000120  -- Tau protein in CSF [status] (AMYPAD)
      WHEN 'csf_abeta_dicho' THEN 2000000113 -- Amyloid beta peptide in CSF [status] (AMYPAD)
      
      -- PET
      WHEN 'pet_vr_classification' THEN 2000000114 -- Amyloid PET Visual Read [status] (AMYPAD)
      
      -- MRI
      WHEN 'mri_vr_gca' THEN 2000000098         -- Global Cortical Atrophy (AMYPAD)
      WHEN 'mri_vr_pca' THEN 2000000107         -- Parietal Cortical Atrophy (AMYPAD)
      WHEN 'mri_vr_mta' THEN 2000000102         -- Medial Temporal Atrophy (AMYPAD)
      WHEN 'mri_vr_fazekas_dwm' THEN 2000000097 -- Fazekas (deep white matter) (AMYPAD)
      WHEN 'mri_vr_wmc' THEN 2000000112         -- White Matter Changes (AMYPAD)

    END AS observation_concept_id,

    -- OBSERVATION_DATE
    '2010-01-01'::DATE + days::INT AS observation_date,

    -- OBSERVATION_TYPE_CONCEPT_ID
    32809 AS observation_type_concept_id, -- Case Report Form

    -- VALUE_AS_NUMBER
    as_number AS value_as_number,

    -- VALUE_AS_STRING
    CASE name
      -- General
      WHEN 'cohort_name' THEN
        CASE as_number
          WHEN 1 THEN 'EPAD LCS'
          WHEN 2 THEN 'ALFA+'
          WHEN 3 THEN 'FACEHBI'
          WHEN 4 THEN 'EMIF-AD (60++)'
          WHEN 5 THEN 'EMIF-AD (90+)'
          WHEN 6 THEN 'FPACK'
          WHEN 7 THEN 'UCL-2010-412'
          WHEN 8 THEN 'H70'
          WHEN 9 THEN 'Microbiota'
          WHEN 10 THEN 'DELCODE'
          WHEN 11 THEN 'AMYPAD DPMS'
        END
        
    END AS value_as_string,

    -- VALUE_AS_CONCEPT_ID
    CASE name
      -- Demographics
      WHEN 'education_years' THEN
        CASE as_concept
          WHEN 1 THEN 1620732 -- (Primary school)
	        WHEN 2 THEN 1620880 -- (High school)
	      END
	   WHEN 'marital_status' THEN
	      CASE as_concept
	        WHEN 0 THEN 21499178 -- (Unmarried)
	        WHEN 1 THEN 45876756 -- (Married)
	      END
	   WHEN 'cohabitation_status' THEN
	      CASE as_concept
	        WHEN 0 THEN 36210148 -- (Alone)
	        WHEN 1 THEN 1620470  -- (Cohabitating)
	      END
	   WHEN 'handedness' THEN
	      CASE as_concept
	        WHEN 1 THEN 4227730 -- (Left handed)
	        WHEN 2 THEN 4263218 -- (Right handed)
	        WHEN 3 THEN 4045863 -- (Ambidextrous)	
	      END
	   
	   -- Family History
    WHEN 'relative_dementia' THEN
        CASE as_concept
          WHEN 0 THEN 45878245 -- (No)
          WHEN 1 THEN 45883182 -- (Father)
          WHEN 2 THEN 45883183 -- (Mother)
          WHEN 3 THEN 45883500 -- (Both)
        END
    
    -- Medical History
    WHEN 'mh_med_hbp' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_cva' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_diabetes_type' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45883360 -- (Type 1)
        WHEN 2 THEN 45877606 -- (Type 2)
      END
    WHEN 'mh_diabetes' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_hbp' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_hyperchol' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_mi' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_chd' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_cold' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_depression' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_ra' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_cancer' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    WHEN 'mh_head_injury' THEN
      CASE as_concept
        WHEN 0 THEN 45878245 -- (No)
        WHEN 1 THEN 45877994 -- (Yes)
      END
    
    -- Lifestyle
    WHEN 'tobacco_history' THEN
      CASE as_concept
    	   WHEN 0 THEN 35821355   -- (Never smoked)
    	   WHEN 1 THEN 35818763   -- (Ex-smoker)
    	   WHEN 2 THEN 35823658   -- (Smokes on most or all days)
    	END
    WHEN 'alcohol_history' THEN
      CASE as_concept
    	   WHEN 0 THEN 45878245  -- (No)
    	   WHEN 1 THEN 45880909  -- (Occasional)
    	   WHEN 2 THEN 45882780  -- (Regular)
    	END
    WHEN 'physical' THEN
      CASE as_concept
    	   WHEN 0 THEN 45878245  -- (No)
    	   WHEN 1 THEN 45883535  -- (Mild)
    	   WHEN 2 THEN 45877983  -- (Moderate)
    	END
    WHEN 'cognitive' THEN
      CASE as_concept
    	   WHEN 1 THEN 1990430   -- (Less than once per year)
    	   WHEN 2 THEN 45883171  -- (Less than once a month)
    	   WHEN 3 THEN 45877773  -- (Several times each month)
    	   WHEN 4 THEN 45879346  -- (Several times a week)
    	   WHEN 5 THEN 45882010  -- (Nearly every day)
    	END
    WHEN 'social' THEN
     CASE as_concept
    	   WHEN 1 THEN 1990430   -- (Less than once per year)
    	   WHEN 2 THEN 45883171  -- (Less than once a month)
    	   WHEN 3 THEN 45877773  -- (Several times each month)
    	   WHEN 4 THEN 45879346  -- (Several times a week)
    	   WHEN 5 THEN 45882010  -- (Nearly every day)
     END
    WHEN 'sleep_dicho' THEN
     CASE as_concept
    	   WHEN 0 THEN 45884153  -- (Normal)
    	   WHEN 1 THEN 45879977  -- (Impaired)
    	END
    WHEN 'diet_cat' THEN
     CASE as_concept
    	   WHEN 1 THEN 2000000005   -- (Low adherence)
    	   WHEN 2 THEN 2000000006   -- (Moderate adherence)
    	   WHEN 3THEN 2000000004    -- (High adherence)
     END
     
    -- Neuropsychological
    WHEN 'cdr_glb' THEN
      CASE as_number -- This is correct, it was stored as number and not concept in source
        WHEN 0 THEN 45884153  -- (Normal)
	      WHEN 1 THEN 45878102  -- (Very mild)
	      WHEN 2 THEN 45883535  -- (Mild)
	      WHEN 3 THEN 45877983  -- (Moderate)
	      WHEN 4 THEN 45883536  -- (Severe)
	    END
    WHEN 'mmse_dicho' THEN
      CASE as_concept
        WHEN 0 THEN 45878245   -- (No)
	      WHEN 1 THEN 45877994   -- (Yes)
      END
    WHEN 'iadl_dicho' THEN
      CASE as_concept
        WHEN 0 THEN 45878245   -- (No)
	      WHEN 1 THEN 45877994   -- (Yes)
	    END
	    
	  -- Neuropsychiatric
	  WHEN 'depression_dicho' THEN
	    CASE as_concept
	      WHEN 0 THEN 45878245   -- (No)
	      WHEN 1 THEN 45877994   -- (Yes)
      END
    WHEN 'anxiety_dicho' THEN
      CASE as_concept
	      WHEN 0 THEN 45878245   -- (No)
	      WHEN 1 THEN 45877994   -- (Yes)
      END
    
    -- CSF
    WHEN 'csf_ptau_dicho' THEN
      CASE as_concept
	      WHEN 0 THEN  45878583  -- (Negative)
	      WHEN 1 THEN 45884084   -- (Positive)
      END
    WHEN 'csf_ttau_dicho' THEN
      CASE as_concept
	      WHEN 0 THEN  45878583  -- (Negative)
	      WHEN 1 THEN 45884084   -- (Positive)
      END
    WHEN 'csf_abeta_dicho' THEN
      CASE as_concept
	      WHEN 0 THEN  45878583  -- (Negative)
	      WHEN 1 THEN 45884084   -- (Positive)
      END
      
    -- PET
    WHEN 'pet_vr_classification' THEN
      CASE as_concept
        WHEN 0 THEN 45878583 -- (Negative)
        WHEN 1 THEN 45884084 -- (Positive)
      END
    -- 
    
	  END AS value_as_concept_id,

    -- QUALIFIER_CONCEPT_ID
    CASE name
      -- Lifestyle
      WHEN 'sleep' THEN
        CASE as_qualifier
          WHEN 1 THEN 2000000072  -- (PSQI)
          WHEN 2 THEN 2000000070  -- (NPI-Q)
          WHEN 3 THEN 2000000077  -- (Self reported)
        END
      WHEN 'cognitive' THEN
        CASE as_qualifier
          WHEN 1 THEN 2000000077  -- (Self-reported)
          WHEN 2 THEN 2000000048  -- (CSA-Q)
          WHEN 3 THEN 2000000066  -- (LEQ)
          WHEN 4 THEN 2000000065  -- (LAQ)
        END
      WHEN 'social' THEN
        CASE as_qualifier
          WHEN 1 THEN 2000000077  -- (Self reported)
          WHEN 2 THEN 2000000066  -- (LEQ)
        END
      WHEN 'physical' THEN
        CASE as_qualifier
          WHEN 1 THEN 2000000077  -- (EPAD LCS)
          WHEN 2 THEN 2000000077  -- (FACEHBI)
          WHEN 3 THEN 2000000071  -- (PASE)
          WHEN 4 THEN 2000000068  -- (MLTPA-Q)
          WHEN 5 THEN 2000000077  -- (days per year)
          WHEN 6 THEN 2000000077  -- (H70)
          WHEN 7 THEN 2000000077  -- (Microbiota)
        END
      WHEN 'diet' THEN
        CASE as_qualifier
          WHEN 1 THEN 2000000067  -- (MeDAS)
          WHEN 2 THEN 2000000062  -- (HATICE)
        END

    -- Neuropsychological
    WHEN 'iadl' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000041  -- (aIADL - Long)
    	   WHEN 2 THEN 2000000042  -- (aIADL - Short)
    	   WHEN 3 THEN 2000000057  -- (FAQ)
      END
    WHEN 'memory_ir' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000074  -- (RBANS)
    	   WHEN 2 THEN 2000000075  -- (RAVLT)
    	   WHEN 3 THEN 2000000055  -- (FCSRT)
    	   WHEN 4 THEN 2000000083  -- (WMS III)
    	   WHEN 5 THEN 2000000040  -- (ADAS-COG)
    	   WHEN 6 THEN 2000000049  -- (CERAD)
    	   WHEN 7 THEN 2000000073  -- (RL/RI-16)
  	   END
    WHEN 'memory_dr' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000074  -- (RBANS)
    	   WHEN 2 THEN 2000000075  -- (RAVLT)
    	   WHEN 3 THEN 2000000055  -- (FCSRT)
    	   WHEN 4 THEN 2000000083  -- (WMS III)
    	   WHEN 5 THEN 2000000040  -- (ADAS-COG)
    	   WHEN 6 THEN 2000000049  -- (CERAD)
    	   WHEN 7 THEN 2000000073  -- (RL/RI-16)
  	   END
    WHEN 'memory_recognition' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000074  -- (RBANS)
    	   WHEN 2 THEN 2000000075  -- (RAVLT)
    	   WHEN 3 THEN 2000000055  -- (FCSRT)
    	   WHEN 4 THEN 2000000083  -- (WMS III)
    	   WHEN 5 THEN 2000000084  -- (WMS IV)
  	   END
    WHEN 'memory_visual' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000074  -- (RBANS)
    	   WHEN 2 THEN 2000000076  -- (RCFT)
  	   END
    WHEN 'language_fluency' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000074  -- (RBANS)
    	   WHEN 2 THEN 2000000043  -- (Animal)
    	   WHEN 3 THEN 2000000056  -- (Fruits)
  	   END
    WHEN 'language_naming' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000074   -- (RBANS)
    	   WHEN 2 THEN 2000000080   -- (WAIS III)
    	   WHEN 3 THEN 2000000081   -- (WAIS IV)
    	   WHEN 4 THEN 2000000082   -- (WAIS R)
    	   WHEN 5 THEN 2000000044   -- (BNT-15)
    	   WHEN 6 THEN 2000000045   -- (BNT-30)
    	   WHEN 7 THEN 2000000046   -- (BNT-60)
    	   WHEN 8 THEN 2000000061   -- (GNT)
    	   WHEN 9 THEN 2000000064   -- (LEXIS)
    	   WHEN 10 THEN 2000000039  -- (ABCD)
  	   END
    WHEN 'attention_dsf' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000074  -- (RBANS)
    	   WHEN 2 THEN 2000000080  -- (WAIS III)
    	   WHEN 3 THEN 2000000081  -- (WAIS IV)
    	   WHEN 4 THEN 2000000082  -- (WAIS R)
    	   WHEN 5 THEN 2000000085  -- (WMS R)
  	  END
    WHEN 'attention_dsb' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000080  -- (WAIS III)
    	   WHEN 2 THEN 2000000081  -- (WAIS IV)
    	   WHEN 3 THEN 2000000082  -- (WAIS R)
    	   WHEN 4 THEN 2000000085  -- (WMS R)
  	   END
    WHEN 'attention_coding' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000074  -- (RBANS)
    	   WHEN 2 THEN 2000000081  -- (WAIS IV)
    	   WHEN 3 THEN 2000000082  -- (WAIS R)
    	   WHEN 4 THEN 2000000079  -- (SDMT)
  	   END
    WHEN 'executive_letter' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000051  -- (FAS)
    	   WHEN 2 THEN 2000000050  -- (DAT)
    	   WHEN 3 THEN 2000000053  -- (P)
    	   WHEN 4 THEN 2000000052  -- (NAK)
    	   WHEN 5 THEN 2000000054  -- (V)
  	   END
    WHEN 'visuospatial' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000074  -- (RBANS)
    	   WHEN 2 THEN 2000000076  -- (RCFT)
    	   WHEN 3 THEN 2000000049  -- (CERAD)
    	   WHEN 4 THEN 2000000079  -- (SDMT)
  	   END
  	   
  	-- Neuropsychiatric
    WHEN 'depression' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000059  -- (GDS-L)
    	   WHEN 2 THEN 2000000059  -- (GDS-S)
    	   WHEN 3 THEN 2000000063  -- (HADS)
    	   WHEN 4 THEN 2000000069  -- (MADRS)
    	END
    WHEN 'anxiety' THEN
      CASE as_qualifier
    	   WHEN 1 THEN 2000000078  -- (STAI)
    	   WHEN 2 THEN 2000000060  -- (GAI-S)
    	   WHEN 3 THEN 2000000063  -- (HADS)
    	   WHEN 4 THEN 2000000070  -- (NPI-Q)
    	   WHEN 5 THEN 2000000047  -- (BSA)
    	END
    --
    END AS qualifier_concept_id,

    -- UNIT_CONCEPT_ID
    CASE name
      -- Demographics
      WHEN 'education_years' THEN 9448   -- year (UCUM)
      
      -- Lifestyle
      WHEN 'tobacco_units' THEN 44777559 -- per week (UCUM)
      WHEN 'alcohol_units' THEN 44777559 -- per week (UCUM)
      
      -- Neurpsychological
      WHEN 'attention_tmta' THEN 8555   -- second (UCUM)
      WHEN 'executive_tmtb' THEN 8555   -- second (UCUM)
      WHEN 'executive_tmtba' THEN 32912 -- Generic unit for indivisible thing (UCUM)
      WHEN 'executive_letter' THEN 8541 -- per minute (UCUM)
      
      --
    END AS unit_concept_id,

    -- QUALIFIER_SOURCE_VALUE
    as_qualifier AS qualifier_source_value,

    -- VALUE_SOURCE_VALUE
    as_number AS value_source_value

FROM pnhs.omop_observation
;