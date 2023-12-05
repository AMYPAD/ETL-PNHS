# OMOP CDM: Prepare AMYPAD PNHS dataset
# This script creates an intermediate set of tables from the original AMYPAD PNHS
# dataset. These tables facilitate the next step to upload its content to OMOP CDM
# Note: Tables are named as "pnhs.omop_[*]"

require(tidyverse, quietly = TRUE)
require(RPostgreSQL, quietly = TRUE)
require(DBI, quietly = TRUE)
require(ODBC, quietly = TRUE)

con <- DBI::dbConnect(odbc::odbc(), "OMOP")

##
# RPostgreSQL::dbRemoveTable(con, DBI::Id(schema = "pnhs", table = "omop_demo"))
# RPostgreSQL::dbRemoveTable(con, DBI::Id(schema = "pnhs", table = "omop_general"))
# RPostgreSQL::dbRemoveTable(con, DBI::Id(schema = "pnhs", table = "omop_visits"))
# RPostgreSQL::dbRemoveTable(con, DBI::Id(schema = "pnhs", table = "omop_location"))
# RPostgreSQL::dbRemoveTable(con, DBI::Id(schema = "pnhs", table = "omop_person"))
# RPostgreSQL::dbRemoveTable(con, DBI::Id(schema = "pnhs", table = "omop_measurement"))
# RPostgreSQL::dbRemoveTable(con, DBI::Id(schema = "pnhs", table = "omop_observation"))


# Functions ----
## If *_days are empty, then they will be filled with visit_days
pnhs_visit <- function(df) {
  left_join(
    x = read.csv("~/files/data/pnhs_raw_general_v202306.csv") %>%
      select(amypad_id, visit_number, visit_days),
    y = df,
    by = c("amypad_id", "visit_number")
  ) %>%
    rename(days = visit_days) %>%
    mutate(
      across(.cols = ends_with("_days"),
             .fns = ~ ifelse(is.na(.x), days, .x))
    ) %>%
    select(-days)
}

## Rearrange NPSY concepts
pnhs_np_score <- function(df, st) {
  df %>%
    select(amypad_id, visit_number,
           starts_with(st) & !ends_with("_dicho")) %>%
    rename(days = paste0(st, "_days")) %>%
    pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
                 names_to = c("name", ".value"),
                 names_pattern = "(.*)_(.*)"
    ) %>%
    rename(any_of(c(as_number = "score", as_qualifier = "quest"))
    )
  
}

pnhs_np_dicho <- function(df, st) {
  df %>%
    select(amypad_id, visit_number,
           starts_with(st) & !ends_with("_score")) %>%
    mutate(name = paste0(st, "_dicho")) %>%
    rename(any_of(c(days = paste0(st, "_days"),
                    as_concept = paste0(st, "_dicho"),
                    as_qualifier = paste0(st, "_quest")))
    ) %>%
    relocate(name, .after = days)
  
}

pnhs_np_z <- function(df, st) {
  df %>%
    select(amypad_id, visit_number, starts_with(st)) %>%
    rename(days = paste0(st, "_days")) %>%
    pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
                 values_to = "as_number") %>%
    drop_na(as_number)
}

# Adjust AMYPAD PNHS dataset ----

## General ----
pnhs_general <- read.csv("~/files/data/pnhs_raw_general_v202306.csv") %>%
  arrange(amypad_id, visit_number)

RPostgreSQL::dbWriteTable(con,
                          DBI::Id(schema = "pnhs", table = "omop_general"),
                          pnhs_general)

## Demographics ----
pnhs_demo <- read.csv("~/files/data/pnhs_raw_demo_v202306.csv") %>%
  pnhs_visit() %>%
  filter(visit_number == 0) %>%
  arrange(amypad_id, visit_number)


RPostgreSQL::dbWriteTable(con,
                          DBI::Id(schema = "pnhs", table = "omop_demo"),
                          pnhs_demo)


## OMOP person ----
omop_person <- left_join(
  x = pnhs_general %>%
    filter(visit_number == 0) %>%
    select(amypad_id, site_name, baseline_age),
  y = pnhs_demo %>%
    filter(visit_number == 0) %>%
    select(amypad_id, sex, ethnic),
  by = "amypad_id"
)

RPostgreSQL::dbWriteTable(con,
                          DBI::Id(schema = "pnhs", table = "omop_person"),
                          omop_person)

remove(omop_person)


## OMOP visit_occurrence ----
omop_visits <- pnhs_general %>%
  select(amypad_id, visit_number, visit_days) %>%
  arrange(amypad_id, visit_number) %>%
  mutate(visit_id = row_number()) %>%
  group_by(amypad_id) %>%
  mutate(prev_visit_id = lag(visit_id)) %>%
  ungroup()

RPostgreSQL::dbWriteTable(con,
                          DBI::Id(schema = "pnhs", table = "omop_visits"),
                          omop_visits)

## OMOP procedure_occurrence ----

p.pet <- read.csv("~/files/data/pnhs_raw_pet_v202306.csv") %>%
  select(amypad_id, visit_number,
         pet_days, pet_tracer) %>%
  #pnhs_visit() %>%
  rename(days = pet_days) %>%
  mutate(procedure = "PET") %>%
  relocate(procedure, .before = pet_tracer) %>%
  drop_na(pet_tracer)

p.mri <- read.csv("~/files/data/pnhs_raw_mri_v202306.csv") %>%
  select(amypad_id, visit_number,
         mri_days) %>%
  drop_na(mri_days) %>%
  #pnhs_visit() %>%
  rename(days = mri_days) %>%
  mutate(procedure = "MRI")

omop_procedure <- left_join(
  x = bind_rows(p.pet, p.mri) %>%
    arrange(amypad_id, days) %>%
    mutate(procedure_id = row_number()),
  y = omop_visits %>% select(amypad_id, visit_number, visit_id),
  by = c("amypad_id", "visit_number"))

RPostgreSQL::dbWriteTable(con,
                          DBI::Id(schema = "pnhs", table = "omop_procedure"),
                          omop_procedure,
                          overwrite = TRUE)

remove(p.pet, p.mri, omop_procedure)


## OMOP Measurements ----
### Genetics
m.genetics <- read.csv("~/files/data/pnhs_raw_genetics_v202306.csv") %>%
  select(amypad_id, visit_number,
         apoe_days, apoe_genotype
  ) %>%
  pnhs_visit() %>%
  rename(days = apoe_days) %>%
  group_by(amypad_id) %>%
  filter(
    visit_number == min(visit_number, na.rm = TRUE) & days == min(days, na.rm = TRUE)) %>%
  ungroup() %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_concept") %>%
  drop_na(as_concept)

### Vitals
m.vitals <- read.csv("~/files/data/pnhs_raw_vitals_v202306.csv") %>%
  select(amypad_id, visit_number,
         vitals_days,
         heart_rate,
         bp_systolic,
         bp_diastolic,
         circumference_waist,
         circumference_hip,
         weight,
         height,
         bmi,
         bmi_cat,
         whtr
  ) %>%
  pnhs_visit() %>%
  rename(days = vitals_days)

m.vitals <- left_join(
  # AS_NUMBER
  x = {
    m.vitals %>%
      select(-bmi_cat) %>%
      pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
                   values_to = "as_number") %>%
      drop_na(as_number)
  },
  # AS_CONCEPT
  y = {
    m.vitals %>%
      select(amypad_id, visit_number, days,
             bmi_cat) %>%
      mutate(name = "bmi") %>%
      rename(as_concept = bmi_cat) %>%
      drop_na(as_concept)
  },
  by = join_by(amypad_id, visit_number, days, name)
)

### Medical History
m.mh <- read.csv("~/files/data/pnhs_raw_mh_v202306.csv") %>%
  select(amypad_id, visit_number,
         mh_days, mh_frs
  ) %>%
  pnhs_visit() %>%
  rename(days = mh_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_number") %>%
  drop_na(as_number)

### Life style
m.lifestyle <- read.csv("~/files/data/pnhs_raw_lifestyle_v202306.csv") %>%
  select(amypad_id, visit_number,
         lifestyle_days, physical_met
  ) %>%
  pnhs_visit() %>%
  rename(days = lifestyle_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_number") %>%
  drop_na(as_number)

### Neuropsychiatric
m.npsychiatr <- read.csv("~/files/data/pnhs_raw_npsychiatr_v202306.csv") %>%
  select(amypad_id, visit_number,
         depression_days,
         anxiety_days,
         depression_zrefpc,
         anxiety_zrefpc
  ) %>%
  pnhs_visit()

m.npsychiatr <- bind_rows(
  pnhs_np_z(m.npsychiatr, "depression"), # Depression Z-score
  pnhs_np_z(m.npsychiatr, "anxiety")     # Anxiety Z-score
)


### Neuropsychologic
m.npsychol <- read.csv("~/files/data/pnhs_raw_npsychol_v202306.csv") %>%
  select(amypad_id, visit_number,
         iadl_days,
         memory_days,
         language_days,
         attention_days,
         executive_days,
         visuospatial_days,
         iadl_zrefpc,
         memory_ir_zrefpc,
         memory_dr_zrefpc,
         memory_recognition_zrefpc,
         memory_visual_zrefpc,
         language_fluency_zrefpc,
         language_naming_zrefpc,
         attention_dsf_zrefpc,
         attention_dsb_zrefpc,
         attention_coding_zrefpc,
         attention_tmta_zrefpc,
         executive_tmtb_zrefpc,
         executive_tmtba_zrefpc,
         executive_letter_zrefpc,
         visuospatial_zrefpc
  ) %>%
  pnhs_visit()

m.npsychol <- bind_rows(
  pnhs_np_z(m.npsychol, "iadl"),        # iADL Z-score
  pnhs_np_z(m.npsychol, "memory"),      # Memory Z-score
  pnhs_np_z(m.npsychol, "language"),    # Language Z-score
  pnhs_np_z(m.npsychol, "attention"),   # Attention Z-score
  pnhs_np_z(m.npsychol, "executive"),   # Executive Z-score
  pnhs_np_z(m.npsychol, "visuospatial") # Executive Z-score
)

### CSF
m.csf <- read.csv("~/files/data/pnhs_raw_csf_v202306.csv") %>%
  select(amypad_id, visit_number,
         csf_days,
         csf_abeta42,
         csf_abeta40,
         csf_abeta42_40,
         csf_ptau,
         csf_ttau,
         csf_abeta_zrefpc,
         csf_ptau_zrefpc,
         csf_ttau_zrefpc
  ) %>%
  pnhs_visit() %>%
  rename(days = csf_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_number") %>%
  drop_na(as_number)

### PET
m.pet <- read.csv("~/files/data/pnhs_raw_pet_v202306.csv") %>%
  select(amypad_id, visit_number,
         pet_days,
         pet_suvr_refwc_gca_gaain,
         pet_cl_refwc_gca_gaain,
         pet_srtm2_dvr_gca_gaain,
         pet_srtm2_r1_gca_gaain
         
  ) %>%
  pnhs_visit() %>%
  rename(days = pet_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_number") %>%
  drop_na(as_number)

## Combine in omop_measurement
omop_measurement <- left_join(
  bind_rows(m.genetics,
            m.vitals,
            m.mh,
            m.lifestyle,
            m.npsychiatr,
            m.npsychol,
            m.csf,
            m.pet),
  omop_visits %>% select(amypad_id, visit_number, visit_id),
  by = c("amypad_id", "visit_number")
) %>%
  arrange(amypad_id, visit_number, name) %>%
  mutate(measurement_id = row_number())

RPostgreSQL::dbWriteTable(con,
                          DBI::Id(schema = "pnhs", table = "omop_measurement"),
                          omop_measurement)

remove(m.genetics, m.vitals, m.mh, m.lifestyle, m.npsychiatr, m.npsychol, m.csf, m.pet,
       omop_measurement)

## OMOP Observations ----
### General
o.general <- pnhs_general %>%
  filter(visit_number == 0) %>%
  select(amypad_id, visit_number,
         visit_days,
         family_id,
         fam_mem_id,
         cohort_name
  ) %>%
  rename(days = visit_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_number"
  ) %>%
  drop_na(as_number) %>%
  mutate(
    days = as.integer(days),
    as_number = as.numeric(as_number)
  )

### Demographics
o.demo <- bind_rows(
  # Marital status, cohabitation status, handedness
  {
    pnhs_demo %>%
      select(amypad_id, visit_number,
             demographics_days,
             marital_status,
             cohabitation_status,
             handedness
      ) %>%
      rename(days = demographics_days) %>%
      pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
                   values_to = "as_concept") %>%
      drop_na(as_concept)
  },
  # Education
  {
    pnhs_demo %>%
      select(amypad_id, visit_number,
             demographics_days,
             education_years,
             education_dicho) %>%
      mutate(name = "education_years") %>%
      rename(days = demographics_days,
             as_number = education_years,
             as_concept = education_dicho) %>%
      drop_na(as_number)
  }
)

### Family History
o.fh <- read.csv("~/files/data/pnhs_raw_fh_v202306.csv") %>%
  select(amypad_id, visit_number,
         relative_days,
         relative_dementia) %>%
  pnhs_visit() %>%
  rename(days = relative_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_concept") %>%
  drop_na(as_concept)

### Medical History
o.mh <- read.csv("~/files/data/pnhs_raw_mh_v202306.csv") %>%
  select(amypad_id, visit_number,
         mh_days,
         mh_med_hbp,
         mh_cva,
         mh_diabetes_type,
         mh_diabetes,
         mh_hbp,
         mh_hyperchol,
         mh_mi,
         mh_chd,
         mh_cold,
         mh_depression,
         mh_ra,
         mh_cancer,
         mh_head_injury
  ) %>%
  pnhs_visit() %>%
  rename(days = mh_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_concept"
  ) %>%
  drop_na(as_concept)

### Life style
o.lifestyle <- read.csv("~/files/data/pnhs_raw_lifestyle_v202306.csv") %>%
  select(amypad_id, visit_number,
         lifestyle_days,
         tobacco_history,
         tobacco_units,
         alcohol_history,
         alcohol_units,
         physical_quest,
         physical_score,
         physical_cat,
         cognitive_quest,
         cognitive_cat,
         social_quest,
         social_cat,
         sleep_quest,
         sleep_score,
         sleep_dicho,
         diet_quest,
         diet_score,
         diet_cat
  ) %>%
  pnhs_visit() %>%
  rename(days = lifestyle_days) %>%
  mutate(
    physical_quest = suppressWarnings(ifelse(physical_quest == "Microbiota", 7, as.numeric(physical_quest)))
  )

o.lifestyle <- reduce(
  list(
    # AS_VALUES
    {
      o.lifestyle %>%
        select(amypad_id, visit_number, days,
               tobacco_units,
               alcohol_units,
               sleep_score,
               diet_score,
               physical_score
        ) %>%
        pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
                     values_to = "as_number") %>%
        mutate(name = str_remove(name, "_score$"))
      
    },
    # AS_CONCEPTS
    {
      o.lifestyle %>%
        select(amypad_id, visit_number, days,
               tobacco_history,
               alcohol_history,
               physical_cat,
               cognitive_cat,
               social_cat,
               sleep_dicho,
               diet_cat
        ) %>%
        pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
                     values_to = "as_concept") %>%
        mutate(name = str_remove(name, "_cat$"),
               name = ifelse(name == "diet", "diet_cat", name))
    },
    # AS_QUALIFIER
    {
      o.lifestyle %>%
        select(amypad_id, visit_number, days,
               sleep_quest, 
               cognitive_quest, 
               social_quest, 
               physical_quest,
               diet_quest
        ) %>%
        pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
                     values_to = "as_qualifier") %>%
        mutate(name = str_remove(name, "_quest$"))
    }
  ), full_join, by = c("amypad_id", "visit_number", "days", "name")
) %>%
  filter(rowSums(is.na(.)) < 3)

### Neuropsychologic
o.npsychol <- read.csv("~/files/data/pnhs_raw_npsychol_v202306.csv") %>%
  select(amypad_id, visit_number,
         cdr_days,
         cdr_glb_score,
         mmse_days,
         mmse_score,
         mmse_dicho,
         iadl_days,
         iadl_quest,
         iadl_score,
         iadl_dicho,
         memory_days,
         memory_ir_quest,
         memory_ir_score,
         memory_dr_quest,
         memory_dr_score,
         memory_recognition_quest,
         memory_recognition_score,
         memory_visual_quest,
         memory_visual_score,
         language_days,
         language_fluency_quest,
         language_fluency_score,
         language_naming_quest,
         language_naming_score,
         attention_days,
         attention_dsf_quest,
         attention_dsf_score,
         attention_dsb_quest,
         attention_dsb_score,
         attention_coding_quest,
         attention_coding_score,
         attention_tmta_score,
         executive_days,
         executive_tmtb_score,
         executive_tmtba_score,
         executive_letter_quest,
         executive_letter_score,
         visuospatial_days,
         visuospatial_quest,
         visuospatial_score
  ) %>%
  pnhs_visit() %>%
  mutate(
    executive_letter_quest = suppressWarnings(ifelse(executive_letter_quest %in% c("KOM", "PGR"),
                                    2, as.numeric(executive_letter_quest)))
  )

o.npsychol <- bind_rows(
  o.npsychol %>% pnhs_np_score("cdr"),  # CDR Score
  o.npsychol %>% pnhs_np_score("mmse"), # MMSE Score
  o.npsychol %>% pnhs_np_dicho("mmse"), # MMSE Dicho
  o.npsychol %>% pnhs_np_score("iadl"), # iADL Score
  o.npsychol %>% pnhs_np_dicho("iadl"), # iADL Dicho
  o.npsychol %>% pnhs_np_score("memory"), #  Score
  o.npsychol %>% pnhs_np_score("language"), #  Score
  o.npsychol %>% pnhs_np_score("attention"), #  Score
  o.npsychol %>% pnhs_np_score("executive"), #  Score
  o.npsychol %>% pnhs_np_score("visuospatial") #  Score
) %>%
  filter(rowSums(is.na(.)) < 3)

### Neuropsychiatric
o.npsychiatr <- read.csv("~/files/data/pnhs_raw_npsychiatr_v202306.csv") %>%
  select(amypad_id, visit_number,
         depression_days,
         depression_score,
         depression_quest,
         depression_dicho,
         anxiety_days,
         anxiety_quest,
         anxiety_score,
         anxiety_dicho
  ) %>%
  pnhs_visit()

o.npsychiatr <- bind_rows(
  o.npsychiatr %>% pnhs_np_score("depression"), # Depression Score
  o.npsychiatr %>% pnhs_np_dicho("depression"), # Depression Dicho
  o.npsychiatr %>% pnhs_np_score("anxiety"),    # Anxiety Score
  o.npsychiatr %>% pnhs_np_dicho("anxiety")     # Anxiety Dicho
) %>%
  filter(rowSums(is.na(.)) < 3)

### CSF
o.csf <- read.csv("~/files/data/pnhs_raw_csf_v202306.csv") %>%
  select(amypad_id, visit_number,
         csf_days,
         csf_ptau_dicho,
         csf_ttau_dicho,
         csf_abeta_dicho
  ) %>%
  pnhs_visit() %>%
  rename(days = csf_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_concept") %>%
  drop_na(as_concept)

### PET VR
o.pet <- read.csv("~/files/data/pnhs_raw_pet_v202306.csv") %>%
  select(amypad_id, visit_number,
         pet_days,
         pet_vr_classification
  ) %>%
  pnhs_visit() %>%
  rename(days = pet_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_concept") %>%
  drop_na(as_concept)

### MRI VR
o.mri <- read.csv("~/files/data/pnhs_raw_mri_v202306.csv") %>%
  select(amypad_id, visit_number,
         mri_days,
         mri_vr_gca,
         mri_vr_pca,
         mri_vr_mta,
         mri_vr_fazekas_dwm,
         mri_vr_wmc
  ) %>%
  pnhs_visit() %>%
  rename(days = mri_days) %>%
  pivot_longer(cols = -c("amypad_id", "visit_number", "days"),
               values_to = "as_number") %>%
  drop_na(as_number)

### Combine & write observation table
omop_observation <- left_join(
  bind_rows(o.general,
            o.demo,
            o.fh,
            o.mh,
            o.lifestyle,
            o.npsychol,
            o.npsychiatr,
            o.csf,
            o.pet,
            o.mri),
  omop_visits %>% select(amypad_id, visit_number, visit_id),
  by = c("amypad_id", "visit_number")
) %>%
  arrange(amypad_id, visit_number, name) %>%
  mutate(observation_id = row_number())

RPostgreSQL::dbWriteTable(con,
                          DBI::Id(schema = "pnhs", table = "omop_observation"),
                          omop_observation)

remove(o.general, o.demo, o.fh, o.mh, o.lifestyle, o.npsychol, o.npsychiatr,
       o.csf, o.pet, o.mri)

## OMOP Observation Period ----
omop_observation_period <- omop_observation %>%
  summarise(start_days = min(days),
            end_days = max(days),
            .by = amypad_id) %>%
  arrange(amypad_id) %>%
  mutate(observation_id = row_number())

RPostgreSQL::dbWriteTable(con,
                          DBI::Id(schema = "pnhs", table = "omop_observation_period"),
                          omop_observation_period)

remove(omop_observation, omop_observation_period)

## OMOP Location ----
omop_location <- pnhs_general %>%
  select(site_name, country) %>%
  unique() %>%
  arrange(site_name)


RPostgreSQL::dbWriteTable(con,
                          DBI::Id(schema = "pnhs", table = "omop_location"),
                          omop_location)
remove(omop_location)

# Clean environment ----
remove(pnhs_demo, pnhs_general,
       omop_visits, o.demo, o.general,
       pnhs_np_dicho, pnhs_np_score, pnhs_np_z, pnhs_visit)

