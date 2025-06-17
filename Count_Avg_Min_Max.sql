select customerName, count(orderNumber) as orders
 from classicmodels.orders t1
inner join classicmodels.customers t2 
on t1.customerNumber = t2.customerNumber
group by customerName
order by orders desc
limit 1;

SELECT paymentDate, avg(amount) as average_payment_received
 from classicmodels.payments
 group by paymentDate
 order by paymentDate;

select customerName, min(orderDate) as Firstorder , max(orderDate) as Lastorder
 from classicmodels.orders t1
inner join classicmodels.customers t2 
on t1.customerNumber = t2.customerNumber
group by customerName;