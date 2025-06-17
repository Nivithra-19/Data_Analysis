SELECT
 contactFirstName, contactLastName
 FROM classicmodels.customers
 union
 SELECT firstName as contactFirstName, 
lastName as contactLastName
 FROM classicmodels.employees;
 
 SELECT 
'customer' as type, 
contactFirstName, 
contactLastName
 FROM classicmodels.customers
 union all
 SELECT 
'employee' as type, 
firstName as contactFirstName, 
lastName as contactLastName
 FROM classicmodels.employees;