SELECT 
      pp.patient_program_id AS 'Patient Program ID', 
      pi.patient_id AS 'Patient ID', 
      pi.identifier AS 'EMR ID', 
      ppa.value_reference as 'Regnum' 
from patient_identifier pi 
join 
      patient_program pp on 
      pi.patient_id=pp.patient_id 
join  
      patient_program_attribute ppa on 
      pp.patient_program_id=ppa.patient_program_id and attribute_type_id=2 
order by pi.identifier ASC;
