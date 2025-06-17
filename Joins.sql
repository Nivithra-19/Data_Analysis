SELECT *
 FROM classicmodels.orders T1
 INNER JOIN classicmodels.customers t2
 ON t1.customernumber = t2.customernumber;
 
select firstName,lastName,customerName from classicmodels.employees t1
left join  classicmodels.customers t2 
on t1.employeeNumber = t2.salesRepEmployeeNumber 
where t2.customerName is not null  ;

SELECT 
FIRSTNAME, 
LASTNAME, 
CUSTOMERNAME
 FROM CLASSICMODELS.CUSTOMERS T1
 RIGHT JOIN CLASSICMODELS.EMPLOYEES T2
 ON T1.SALESREPEMPLOYEENUMBER = 
T2.EMPLOYEENUMBER;

select t2.contactFirstName, t2.contactLastName, t1.orderDate, t1.status
 from classicmodels.orders t1 
left join classicmodels.customers t2 
on t1.customerNumber = t2.customerNumber;

select * from classicmodels.orders where customerNumber is null;
select t1.contactFirstName, t1.contactLastName, t2.orderDate, t2.orderNumber
 from classicmodels.customers t1
inner join  classicmodels.orders t2 
on t1.customerNumber = t2.customerNumber;