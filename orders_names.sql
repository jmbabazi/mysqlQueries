/*
          All TB Drugs
             concept_id for All TB drugs is "1730"
             This query outputs all the drug names in the orders table
*/
             

select 
(
select 
      name 
   from concept_name cn where 
   cn.concept_id=orders.concept_id and locale='en' and
concept_name_type='FULLY_SPECIFIED' and voided=0
) 
from orders where concept_id IN (
                                  select concept_id 
                                  from concept_set where concept_set=1730
                                  ) and voided=0;
