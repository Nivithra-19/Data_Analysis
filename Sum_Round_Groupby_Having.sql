SELECT paymentDate, sum(amount) as total_payments
 FROM classicmodels.payments
 group by paymentDate
 having total_payments > 50000
 order by total_payments desc;
 
 SELECT paymentDate, round( sum(amount), 1)  as total_payments 
FROM classicmodels.payments
 group by paymentDate;