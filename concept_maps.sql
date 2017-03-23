use openmrs;
show tables;
desc concept_reference_map;
desc concept_reference_term;
desc concept_reference_term_map_view;
desc concept_map_type;
desc concept_reference_source;
desc concept_reference_term_map;
desc concept_reference_map;

select * from concept_reference_term where uuid="e0fa0af0-0ff0-11e7-93ae-91161f002671";
select * from concept_reference_term_map_view;
select * from concept_reference_source;
select * from concept_reference_map;
select * from concept_name_tag;
select * from concept_name_tag_map;
select * from concept_name_tag_map;


insert into concept_reference_term(concept_reference_term_id, concept_source_id, code, creator, date_created, retired, uuid) values (NULL, 37, "lab_yr_est", 4, NOW(), 1, "e0fa0af0-0ff0-11e7-93ae-91161f002671");
insert into concept_reference_map(concept_map_id, concept_reference_term_id, creator, date_created, concept_id, UUID) values (NULL, 1469, 4, NOW(), 2855, "e0fa0ba0-0ff0-11e7-93ae-91161f002671" );

use information_schema;
SELECT *
FROM
  KEY_COLUMN_USAGE
WHERE
  REFERENCED_TABLE_NAME = 'concept_reference_map'
  AND REFERENCED_COLUMN_NAME = 'concept_map_type_id'
  AND TABLE_SCHEMA = 'openmrs';
