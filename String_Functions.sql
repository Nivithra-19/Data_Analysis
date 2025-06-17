SELECT *, 
cast(paymentDate as datetime) as datetime_type
 FROM classicmodels.payments;
 
 SELECT CUSTOMERNUMBER,
 PAYMENTDATE,
 SUBSTRING(PAYMENTDATE, 1,7) AS MONTH_KEY
 FROM CLASSICMODELS.PAYMENTS;
 
 SELECT EMPLOYEENUMBER,
 LASTNAME,
 FIRSTNAME,
 CONCAT(firstName, ' ', Lastname) AS FULLNAME
 FROM classicmodels.employees;
 