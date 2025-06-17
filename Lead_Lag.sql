SELECT customernumber,
 paymentdate,
 amount,
 lead(amount) over (partition by customernumber order by 
paymentdate) as next_payment
 FROM classicmodels.payments;
 
  SELECT customernumber,
 paymentdate,
 amount,
 lag(amount) over (partition by customernumber order by 
paymentdate) as previous_payment
 FROM classicmodels.payments;