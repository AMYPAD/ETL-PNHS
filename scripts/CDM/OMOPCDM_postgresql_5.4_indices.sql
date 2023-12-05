/*postgresql OMOP CDM Indices

  There are no unique indices created because it is assumed that the primary key constraints have been run prior to
  implementing indices.
*/


/************************

Standardized clinical data

************************/

CREATE INDEX idx_person_id  ON cdmdatabaseschema.person  (person_id ASC);
CLUSTER cdmdatabaseschema.person  USING idx_person_id ;
CREATE INDEX idx_gender ON cdmdatabaseschema.person (gender_concept_id ASC);

CREATE INDEX idx_observation_period_id_1  ON cdmdatabaseschema.observation_period  (person_id ASC);
CLUSTER cdmdatabaseschema.observation_period  USING idx_observation_period_id_1 ;

CREATE INDEX idx_visit_person_id_1  ON cdmdatabaseschema.visit_occurrence  (person_id ASC);
CLUSTER cdmdatabaseschema.visit_occurrence  USING idx_visit_person_id_1 ;
CREATE INDEX idx_visit_concept_id_1 ON cdmdatabaseschema.visit_occurrence (visit_concept_id ASC);

CREATE INDEX idx_visit_det_person_id_1  ON cdmdatabaseschema.visit_detail  (person_id ASC);
CLUSTER cdmdatabaseschema.visit_detail  USING idx_visit_det_person_id_1 ;
CREATE INDEX idx_visit_det_concept_id_1 ON cdmdatabaseschema.visit_detail (visit_detail_concept_id ASC);
CREATE INDEX idx_visit_det_occ_id ON cdmdatabaseschema.visit_detail (visit_occurrence_id ASC);

CREATE INDEX idx_condition_person_id_1  ON cdmdatabaseschema.condition_occurrence  (person_id ASC);
CLUSTER cdmdatabaseschema.condition_occurrence  USING idx_condition_person_id_1 ;
CREATE INDEX idx_condition_concept_id_1 ON cdmdatabaseschema.condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id_1 ON cdmdatabaseschema.condition_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_drug_person_id_1  ON cdmdatabaseschema.drug_exposure  (person_id ASC);
CLUSTER cdmdatabaseschema.drug_exposure  USING idx_drug_person_id_1 ;
CREATE INDEX idx_drug_concept_id_1 ON cdmdatabaseschema.drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id_1 ON cdmdatabaseschema.drug_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_procedure_person_id_1  ON cdmdatabaseschema.procedure_occurrence  (person_id ASC);
CLUSTER cdmdatabaseschema.procedure_occurrence  USING idx_procedure_person_id_1 ;
CREATE INDEX idx_procedure_concept_id_1 ON cdmdatabaseschema.procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id_1 ON cdmdatabaseschema.procedure_occurrence (visit_occurrence_id ASC);

CREATE INDEX idx_device_person_id_1  ON cdmdatabaseschema.device_exposure  (person_id ASC);
CLUSTER cdmdatabaseschema.device_exposure  USING idx_device_person_id_1 ;
CREATE INDEX idx_device_concept_id_1 ON cdmdatabaseschema.device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id_1 ON cdmdatabaseschema.device_exposure (visit_occurrence_id ASC);

CREATE INDEX idx_measurement_person_id_1  ON cdmdatabaseschema.measurement  (person_id ASC);
CLUSTER cdmdatabaseschema.measurement  USING idx_measurement_person_id_1 ;
CREATE INDEX idx_measurement_concept_id_1 ON cdmdatabaseschema.measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id_1 ON cdmdatabaseschema.measurement (visit_occurrence_id ASC);

CREATE INDEX idx_observation_person_id_1  ON cdmdatabaseschema.observation  (person_id ASC);
CLUSTER cdmdatabaseschema.observation  USING idx_observation_person_id_1 ;
CREATE INDEX idx_observation_concept_id_1 ON cdmdatabaseschema.observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id_1 ON cdmdatabaseschema.observation (visit_occurrence_id ASC);

CREATE INDEX idx_death_person_id_1  ON cdmdatabaseschema.death  (person_id ASC);
CLUSTER cdmdatabaseschema.death  USING idx_death_person_id_1 ;

CREATE INDEX idx_note_person_id_1  ON cdmdatabaseschema.note  (person_id ASC);
CLUSTER cdmdatabaseschema.note  USING idx_note_person_id_1 ;
CREATE INDEX idx_note_concept_id_1 ON cdmdatabaseschema.note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id_1 ON cdmdatabaseschema.note (visit_occurrence_id ASC);

CREATE INDEX idx_note_nlp_note_id_1  ON cdmdatabaseschema.note_nlp  (note_id ASC);
CLUSTER cdmdatabaseschema.note_nlp  USING idx_note_nlp_note_id_1 ;
CREATE INDEX idx_note_nlp_concept_id_1 ON cdmdatabaseschema.note_nlp (note_nlp_concept_id ASC);

CREATE INDEX idx_specimen_person_id_1  ON cdmdatabaseschema.specimen  (person_id ASC);
CLUSTER cdmdatabaseschema.specimen  USING idx_specimen_person_id_1 ;
CREATE INDEX idx_specimen_concept_id_1 ON cdmdatabaseschema.specimen (specimen_concept_id ASC);

CREATE INDEX idx_fact_relationship_id1 ON cdmdatabaseschema.fact_relationship (domain_concept_id_1 ASC);
CREATE INDEX idx_fact_relationship_id2 ON cdmdatabaseschema.fact_relationship (domain_concept_id_2 ASC);
CREATE INDEX idx_fact_relationship_id3 ON cdmdatabaseschema.fact_relationship (relationship_concept_id ASC);

/************************

Standardized health system data

************************/

CREATE INDEX idx_location_id_1  ON cdmdatabaseschema.location  (location_id ASC);
CLUSTER cdmdatabaseschema.location  USING idx_location_id_1 ;

CREATE INDEX idx_care_site_id_1  ON cdmdatabaseschema.care_site  (care_site_id ASC);
CLUSTER cdmdatabaseschema.care_site  USING idx_care_site_id_1 ;

CREATE INDEX idx_provider_id_1  ON cdmdatabaseschema.provider  (provider_id ASC);
CLUSTER cdmdatabaseschema.provider  USING idx_provider_id_1 ;

/************************

Standardized health economics

************************/

CREATE INDEX idx_period_person_id_1  ON cdmdatabaseschema.payer_plan_period  (person_id ASC);
CLUSTER cdmdatabaseschema.payer_plan_period  USING idx_period_person_id_1 ;

CREATE INDEX idx_cost_event_id  ON cdmdatabaseschema.cost (cost_event_id ASC);

/************************

Standardized derived elements

************************/

CREATE INDEX idx_drug_era_person_id_1  ON cdmdatabaseschema.drug_era  (person_id ASC);
CLUSTER cdmdatabaseschema.drug_era  USING idx_drug_era_person_id_1 ;
CREATE INDEX idx_drug_era_concept_id_1 ON cdmdatabaseschema.drug_era (drug_concept_id ASC);

CREATE INDEX idx_dose_era_person_id_1  ON cdmdatabaseschema.dose_era  (person_id ASC);
CLUSTER cdmdatabaseschema.dose_era  USING idx_dose_era_person_id_1 ;
CREATE INDEX idx_dose_era_concept_id_1 ON cdmdatabaseschema.dose_era (drug_concept_id ASC);

CREATE INDEX idx_condition_era_person_id_1  ON cdmdatabaseschema.condition_era  (person_id ASC);
CLUSTER cdmdatabaseschema.condition_era  USING idx_condition_era_person_id_1 ;
CREATE INDEX idx_condition_era_concept_id_1 ON cdmdatabaseschema.condition_era (condition_concept_id ASC);

/**************************

Standardized meta-data

***************************/

CREATE INDEX idx_metadata_concept_id_1  ON cdmdatabaseschema.metadata  (metadata_concept_id ASC);
CLUSTER cdmdatabaseschema.metadata  USING idx_metadata_concept_id_1 ;

/**************************

Standardized vocabularies

***************************/

CREATE INDEX idx_concept_concept_id  ON cdmdatabaseschema.concept  (concept_id ASC);
CLUSTER cdmdatabaseschema.concept  USING idx_concept_concept_id ;
CREATE INDEX idx_concept_code ON cdmdatabaseschema.concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON cdmdatabaseschema.concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON cdmdatabaseschema.concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON cdmdatabaseschema.concept (concept_class_id ASC);

CREATE INDEX idx_vocabulary_vocabulary_id  ON cdmdatabaseschema.vocabulary  (vocabulary_id ASC);
CLUSTER cdmdatabaseschema.vocabulary  USING idx_vocabulary_vocabulary_id ;

CREATE INDEX idx_domain_domain_id  ON cdmdatabaseschema.domain  (domain_id ASC);
CLUSTER cdmdatabaseschema.domain  USING idx_domain_domain_id ;

CREATE INDEX idx_concept_class_class_id  ON cdmdatabaseschema.concept_class  (concept_class_id ASC);
CLUSTER cdmdatabaseschema.concept_class  USING idx_concept_class_class_id ;

CREATE INDEX idx_concept_relationship_id_1  ON cdmdatabaseschema.concept_relationship  (concept_id_1 ASC);
CLUSTER cdmdatabaseschema.concept_relationship  USING idx_concept_relationship_id_1 ;
CREATE INDEX idx_concept_relationship_id_2 ON cdmdatabaseschema.concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON cdmdatabaseschema.concept_relationship (relationship_id ASC);

CREATE INDEX idx_relationship_rel_id  ON cdmdatabaseschema.relationship  (relationship_id ASC);
CLUSTER cdmdatabaseschema.relationship  USING idx_relationship_rel_id ;

CREATE INDEX idx_concept_synonym_id  ON cdmdatabaseschema.concept_synonym  (concept_id ASC);
CLUSTER cdmdatabaseschema.concept_synonym  USING idx_concept_synonym_id ;

CREATE INDEX idx_concept_ancestor_id_1  ON cdmdatabaseschema.concept_ancestor  (ancestor_concept_id ASC);
CLUSTER cdmdatabaseschema.concept_ancestor  USING idx_concept_ancestor_id_1 ;
CREATE INDEX idx_concept_ancestor_id_2 ON cdmdatabaseschema.concept_ancestor (descendant_concept_id ASC);

CREATE INDEX idx_source_to_concept_map_3  ON cdmdatabaseschema.source_to_concept_map  (target_concept_id ASC);
CLUSTER cdmdatabaseschema.source_to_concept_map  USING idx_source_to_concept_map_3 ;
CREATE INDEX idx_source_to_concept_map_1 ON cdmdatabaseschema.source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_2 ON cdmdatabaseschema.source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_c ON cdmdatabaseschema.source_to_concept_map (source_code ASC);

CREATE INDEX idx_drug_strength_id_1  ON cdmdatabaseschema.drug_strength  (drug_concept_id ASC);
CLUSTER cdmdatabaseschema.drug_strength  USING idx_drug_strength_id_1 ;
CREATE INDEX idx_drug_strength_id_2 ON cdmdatabaseschema.drug_strength (ingredient_concept_id ASC);


--Additional v6.0 indices

--CREATE CLUSTERED INDEX idx_survey_person_id_1 ON cdmdatabaseschema.survey_conduct (person_id ASC);


--CREATE CLUSTERED INDEX idx_episode_person_id_1 ON cdmdatabaseschema.episode (person_id ASC);
--CREATE INDEX idx_episode_concept_id_1 ON cdmdatabaseschema.episode (episode_concept_id ASC);

--CREATE CLUSTERED INDEX idx_episode_event_id_1 ON cdmdatabaseschema.episode_event (episode_id ASC);
--CREATE INDEX idx_ee_field_concept_id_1 ON cdmdatabaseschema.episode_event (event_field_concept_id ASC);