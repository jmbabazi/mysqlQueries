select o.person_id,
o.encounter_id, o.voided,
o.obs_id, obs_group_id,
o.concept_id, cnq.name "Question concept",
o.value_group_id, o.value_boolean, o.value_coded, cna.concept_id, cna.name "Answer concept", o.value_datetime, o.value_numeric, o.value_text, o.comments,
group_concat(distinct case when crs.name = 'PIH' then crt.code end separator ',') "PIH question Mapping",
group_concat(distinct case when crs.name = 'CIEL' then crt.code end separator ',') "CIEL question Mapping",
group_concat(distinct case when crsa.name = 'PIH' then crta.code end separator ',') "PIH Answer Mapping",
group_concat(distinct case when crsa.name = 'CIEL' then crta.code end separator ',') "CIEL Answer Mapping"
from obs o
INNER JOIN concept_name cnq on cnq.concept_id = o.concept_id and cnq.locale = 'en' and cnq.locale_preferred = '1' and cnq.voided = 0
LEFT OUTER JOIN concept_name cna on o.value_coded = cna.concept_id and cna.locale = 'en' and cna.locale_preferred = '1' and cna.voided = 0
LEFT OUTER JOIN concept_reference_map crm on crm.concept_id = o.concept_id
LEFT OUTER JOIN concept_reference_term crt on crt.concept_reference_term_id = crm.concept_reference_term_id
LEFT OUTER JOIN concept_reference_source crs on crs.concept_source_id = crt.concept_source_id
LEFT OUTER JOIN concept_reference_map crma on crma.concept_id = o.value_coded
LEFT OUTER JOIN concept_reference_term crta on crta.concept_reference_term_id = crma.concept_reference_term_id
LEFT OUTER JOIN concept_reference_source crsa on crsa.concept_source_id = crta.concept_source_id
where 1=1
and o.voided = 0
AND date(o.obs_datetime) >= date('2016-01-15') -- :startDate
AND date(o.obs_datetime) <= date('2016-01-15') -- :endDate
group by o.obs_id
order by  obs_id;
