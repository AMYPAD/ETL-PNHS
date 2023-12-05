

CREATE TABLE results.COHORT_DEFINITION (
			cohort_definition_id integer NOT NULL,
			cohort_definition_name varchar(255) NOT NULL,
			cohort_definition_description TEXT NULL,
			definition_type_concept_id integer NOT NULL,
			cohort_definition_syntax TEXT NULL,
			subject_concept_id integer NOT NULL,
			cohort_initiation_date date NULL );
			
-- ALTER TABLE results.COHORT_DEFINITION ADD CONSTRAINT fpk_COHORT_DEFINITION_cohort_definition_id FOREIGN KEY (cohort_definition_id) REFERENCES results.COHORT (COHORT_DEFINITION_ID);

ALTER TABLE results.COHORT_DEFINITION ADD CONSTRAINT fpk_COHORT_DEFINITION_definition_type_concept_id FOREIGN KEY (definition_type_concept_id) REFERENCES cdmdatabaseschema.CONCEPT (CONCEPT_ID);

ALTER TABLE results.COHORT_DEFINITION ADD CONSTRAINT fpk_COHORT_DEFINITION_subject_concept_id FOREIGN KEY (subject_concept_id) REFERENCES cdmdatabaseschema.CONCEPT (CONCEPT_ID);