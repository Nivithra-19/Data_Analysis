select 
case when creditLimit < 75000 then 'a: Less than $75k'
 when creditLimit between 75000 and 100000 then 'b: $75k - 100k'
 when creditLimit between 100000 and 150000 then 'c: $100k - $150k'
 when creditLimit > 150000 then 'd: Over $150k'
 else 'Other' end as credit_limit_grp,
 count(distinct c.customernumber) as customers
 from classicmodels.customers c
 group by 1;