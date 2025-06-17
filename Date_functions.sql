 select ordernumber,
 orderdate,
 year(orderdate) as year,
 month(orderdate) as month,
 day(orderdate) as day
 from classicmodels.orders;

select a.ordernumber, 
datediff(requireddate, orderdate) as days_until_required
 from classicmodels.orders a;
 
 select a.ordernumber, 
orderdate,
 date_add(orderdate, interval 1 year) as one_year_from_order
 from classicmodels.orders a;
 
 select a.ordernumber, 
orderdate,
 date_sub(orderdate, interval 2 month) as two_months_ago
 from classicmodels.orders a; 
  