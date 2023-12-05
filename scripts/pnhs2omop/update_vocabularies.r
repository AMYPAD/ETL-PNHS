# OMOP CDM: Update vocabulary with AMYPAD PNHS info
# This script updates the content of the OMOP CDM tables related to the vocabularies.
# In addition, specific information of the AMYPAD PNHS vocabulary is added


require(tidyverse, quietly = TRUE)


# CONCEPT
bind_rows(
  read_tsv("files/scripts/CDM/vocabularies/CONCEPT.csv", col_types = cols(.default =  col_character())),
  read_tsv("files/scripts/CDM/vocabularies/pnhs_vocabulary_20230804.csv", col_types = cols(.default =  col_character()))
) %>%
  mutate(concept_name = ifelse(concept_id == "36311145", "NA", concept_name)) %>% 
  write_tsv(file = "CDM/vocabularies/CONCEPT2.csv", na = "")

# VOCABULARY
read_delim("files/scripts/CDM/vocabularies/VOCABULARY.csv", delim = "\t", show_col_types = FALSE) %>%
  add_row(vocabulary_id = "AMYPAD PNHS",
          vocabulary_name = "Amyloid imaging to prevent Alzheimer’s disease: Prognostic and Natural History Study (AMYPAD PNHS)",
          vocabulary_reference = "http://amypad.eu",
          vocabulary_version = "AMYPAD PNHS v202308",
          vocabulary_concept_id = 2100000001
  ) %>%
  write_tsv(file = "files/scripts/CDM/vocabularies/VOCABULARY2.csv", na = "")

# CONCEPT_CLASS
read_delim("files/scripts/CDM/vocabularies/CONCEPT_CLASS.csv", delim = "\t", show_col_types = FALSE) %>%
  add_row(concept_class_id = "ID",
          concept_class_name = "Family Identification",
          concept_class_concept_id = 2100000002
            ) %>%
  add_row(concept_class_id = "Tracer",
          concept_class_name = "PET Tracer",
          concept_class_concept_id = 2100000003
  ) %>%
  write_tsv(file = "files/scripts/CDM/vocabularies/CONCEPT_CLASS2.csv", na = "")
