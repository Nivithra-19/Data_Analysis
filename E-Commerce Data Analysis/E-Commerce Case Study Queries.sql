use ecommerce;

select * from customers;
select * from products;
select * from orders;
select * from order_details;

-- Cleaning order_date
select *,str_to_date(order_date,'%Y-%m-%d') as OrderDate from orders;
 
-- CUSTOMER ANALYSIS
-- Location wise customer purchase analysis
select location as Location, count(*) as Count_of_Customers,
round((count(*)/(select count(*) from customers))*100,2) as Percentage_contribution,
sum(total_amount) as Total_Order_Amount,
round(avg(total_amount),2) as Avg_Purchase_Value
from customers c inner join orders o on o.customer_id = c.ï»¿customer_id
group by location order by Percentage_contribution desc;

-- Top 3 cities with maximum no of customers
select location, count(*) as number_of_customers,
round((count(*)/(select count(*) from customers))*100,2) as Percentage_contribution,
sum(total_amount) as Total_Order_Amount,
round(avg(total_amount),2) as Avg_Purchase_Value
from customers c left join orders o on o.customer_id = c.ï»¿customer_id
group by location order by number_of_customers desc
limit 3;

-- Date wise customer analysis
-- Year wise count of customers who purchased products
select year(str_to_date(order_date,'%Y-%m-%d')) as Year_of_Purchase, count(*) as No_of_Customers,
lag(count(*)) over (order by year(str_to_date(order_date,'%Y-%m-%d'))) as Prev_Customer_Count,
sum(total_amount) as Total_Order_Amount,
round(avg(total_amount),2) as Avg_Order_Value 
from customers c
inner join orders o on o.customer_id = c.ï»¿customer_id
group by year(str_to_date(order_date,'%Y-%m-%d')) ;

-- YOY growth
with year_cte as
(
select year(str_to_date(order_date,'%Y-%m-%d')) as Year_of_Purchase, count(*) as No_of_Customers,
lag(count(*)) over (order by year(str_to_date(order_date,'%Y-%m-%d'))) as Prev_Customer_Count,
sum(total_amount) as Total_Order_Amount,
round(avg(total_amount),2) as Avg_Order_Value
 from customers c
inner join orders o on o.customer_id = c.ï»¿customer_id
group by year(str_to_date(order_date,'%Y-%m-%d'))
)
select *,round((No_of_Customers/Prev_Customer_Count-1)*100,3) as YOY_Growth from year_cte;

-- Month wise count of customers who purchased products
select date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m') as Month_of_Purchase, count(*) as No_of_Customers,
lag(count(*)) over (order by date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m')) as Prev_Customer_Count,
sum(total_amount) as Total_Order_Amount,
round(avg(total_amount),2) as Avg_Order_Value
 from customers c
inner join orders o on o.customer_id = c.ï»¿customer_id
group by date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m');

-- MOM growth
with month_cte as
(
select date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m') as Month_of_Purchase, count(*) as No_of_Customers,
lag(count(*)) over (order by date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m')) as Prev_Customer_Count,
sum(total_amount) as Total_Order_Amount,
round(avg(total_amount),2) as Avg_Purchase_Value
 from customers c
inner join orders o on o.customer_id = c.ï»¿customer_id
group by date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m') 
)
select *,round((No_of_Customers/Prev_Customer_Count-1)*100,3) as MOM_Growth from month_cte;

-- Categorize Customers into Groups based on the no of orders and purchase amount
with cust_cte as
(
	select c.ï»¿customer_id as Customer_ID, count(ï»¿order_id) as No_of_Orders, 
    sum(total_amount) as Total_Purchase_Amount from customers c
	inner join orders o on o.customer_id = c.ï»¿customer_id
	group by c.ï»¿customer_id
),
Cus_Categories AS
(
select *,
  case
    when No_of_Orders >= 4 and Total_Purchase_Amount >= 500000 then 'Premium and Loyal '
    when No_of_Orders <= 2 and Total_Purchase_Amount >= 300000 then 'High Value but Low Purchase Frequency'
	when No_of_Orders >= 4 and Total_Purchase_Amount between 200000 and 499999 then 'Frequent Puchases but Moderate Spend'
    when No_of_Orders between 2 and 3 and Total_Purchase_Amount between 150000 and 299999 then 'Mid-Range'
    when No_of_Orders <= 2 and Total_Purchase_Amount < 150000 then 'Low Value'
    when No_of_Orders = 1 and Total_Purchase_Amount >= 200000 then 'High Spender but at risk of Churn'
    else 'Others'
  end as Customer_Category
from cust_cte
)
select Customer_Category, count(*) as Customer_Count from Cus_Categories group by Customer_Category;


-- Category wise Customer Reach
select p.category, count(distinct o.customer_id) as unique_customers,
sum(quantity) as Purchase_Quantity, round(avg(total_amount)) as Avg_Purchase_Value, round(avg(p.price*od.quantity)) as Avg_Order_Value
from products p
left join order_details od on od.product_id = p.ï»¿product_id
left join orders o on o.ï»¿order_id= od.ï»¿order_id
group by p.category
order by unique_customers desc;

-- Engagement Depth Analysis
select 
    order_count as NumberOfOrders,
    count(*) as CustomerCount
from (
    select 
        customer_id,
        count(*) as order_count
    from Orders
    group by customer_id
) customer_orders
group by order_count
order by order_count;

-- MoM growth in customer base
select 
    date_format(first_purchase_date, '%Y-%m') as FirstPurchaseMonth,
    count(*) as TotalNewCustomers
from (
    select 
        customer_id,
        min(order_date) as First_Purchase_Date
    from orders
    group by customer_id
) Customer_First_Purchase
group by date_format(First_Purchase_Date, '%Y-%m')
order by FirstPurchaseMonth ;


-- PRODUCTS ANALYSIS
-- Rank products based on price in each category(highest to lowest)
select 
    ï»¿product_id as Product_ID,
    name as Product_Name,
    category as Product_Category,
    price as Price,
    rank() over (partition by category order by price desc) as Rank_in_Category    
from products
order by category, price desc;

-- Category Analysis
select
    category as Product_Category,
    count(*) as Total_Product_Count,
    round(avg(price), 2) as Avg_Price,
    min(price) as Min_Price,
    max(price) as Max_Price,
    round(avg(price), 2) - min(price) as Price_Variance_Low,
    max(price) - round(avg(price), 2) as Price_Variance_High
from products
group by category
order by Avg_Price desc;

-- Classification of Products into different Price Groups
select 
    case 
        when price < 10000 then 'Budget'
        when price between 10000 and 30000 then 'Mid-range'
        when price > 30000 then 'Premium'
    end as Price_Grps,
    count(*) as Product_Count,
    round(avg(price), 2) as Avg_Price_in_Grp,
    group_concat(name separator ', ') as Products_in_Grp
from products
group by 
    case 
        when price < 10000 then 'Budget'
        when price between 10000 and 30000 then 'Mid-range'
        when price > 30000 then 'Premium'
    end
order by  Avg_Price_in_Grp;

-- Category wise performance 
select
    p.Category as Product_Category, 
    count(*) as 'No of Orders', 
    sum(od.quantity) as Total_Order_Qty, 
    round(avg(od.quantity),2) as Avg_Order_Qty,
    round(avg(p.price), 2) as Avg_Price, 
    round(avg(p.price * od.quantity),2) as Avg_Order_Value,
    sum(p.price * od.quantity) as Total_Revenue,
    round((sum(p.price * od.quantity) / (
        select sum(p2.price * od2.quantity) 
        from products p2 
        inner join order_details od2 on od2.product_id = p2.ï»¿product_id
    )) * 100, 2) as 'Percentage Contribution of Revenue'
from products p
inner join order_details od on od.product_id = p.ï»¿product_id
group by p.Category
order by Total_Revenue desc;

-- Product wise performance
select 
    p.name as Product_Name, 
    count(*) as 'No of Orders',
    sum(od.quantity) as Total_Order_Qty, 
    round(avg(od.quantity),2) as Avg_Order_Qty,
    round(avg(p.price), 2) as Avg_Price, 
    sum(p.price * od.quantity) as Total_Revenue,
    round(avg(p.price * od.quantity),2) as Avg_Order_Value,
    round((sum(p.price * od.quantity)/(
    select sum(p2.price * od2.quantity) 
    from products p2 
    inner join order_details od2 on od2.product_id = p2.ï»¿product_id
    )) * 100,2) as 'Percentage Contribution of Revenue'
 from products p 
inner join order_details od on od.product_id = p.ï»¿product_id
group by p.name
order by Total_Revenue desc;

-- Low Engagement Products (Products that have been purchased by less than 40% of customer base)
with product_cte as 
(
select
    p.ï»¿product_id AS Product_id, 
    p.name AS Product_Name, 
    p.category as Product_Category,
    count(distinct o.customer_id) AS UniqueCustomerCount,
    round((count(distinct o.customer_id) * 100.0 / total_customers.total_count), 2) AS CustomerPercentage,
    sum(total_amount) as Total_Purchase_Amount,
    sum(p.price*od.quantity) as Total_Revenue,
    round(avg(total_amount)) as Avg_Purchase_Value, 
	round(avg(p.price*od.quantity),2) as Avg_Order_Value,
    sum(quantity) as Total_Purchase_Qty
from products p 
inner join order_details od on od.product_id = p.ï»¿product_id
inner join orders o on od.ï»¿order_id = o.ï»¿order_id
inner join customers c on o.customer_id = c.ï»¿customer_id
cross join (
    select count(distinct ï»¿customer_id) as total_count 
    from customers
) total_customers
group by p.ï»¿product_id, p.name, p.category, total_customers.total_count
having count(distinct o.customer_id) < (total_customers.total_count * 0.4)
)
select Product_id, Product_Name, Product_Category, UniqueCustomerCount, Total_Purchase_Qty, Total_Revenue, Avg_Order_Value from product_cte;

-- Product Turnover Rate
select p.name as Product_Name, count(*)as SalesFrequency, sum(p.price*od.quantity) as Total_Revenue,
round(avg(p.price*od.quantity),2) as Avg_Order_Value
from order_details od
inner join products p on p.ï»¿product_id = od.product_id
group by p.name 
order by SalesFrequency desc;


-- ORDERS ANALYSIS
-- MOM growth
with mom_cte as
(
	select  date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m') as Month,
    sum(total_amount) as Total_Order_Amount,
    avg(total_amount) as Avg_Order_Amount,
    lag(sum(total_amount)) over (order by date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m')) as Prev_Month_Order_Value
    from orders
    group by  date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m')  
    order by Month
)
select *, round((Total_Order_Amount/Prev_Month_Order_Value-1)*100,3) as MoM_Growth from mom_cte;

-- Fluctuations in Average purchase value
with monthly_order_value as
(
	select date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m')  as Month,
	round(avg(total_amount),2) as Avg_Purchase_Value , 
	lag(avg(total_amount)) over (order by date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m' )) as Prev_value
	from orders
	group by date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m') 
)
select Month, Avg_Purchase_Value, round(Avg_Purchase_Value-Prev_value,2) as Change_In_Value from monthly_order_value
order by Change_In_Value desc;

-- Sales Trend Anlaysis
with month_cte as
(
	select date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m') as Month, 
	sum(total_amount) as Total_Sales,
	lag(sum(total_amount)) over (order by date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m' )) as Prev_Month_Sales
	from orders
	group by  date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m')
)
select Month, Total_Sales, round(((Total_Sales/Prev_Month_Sales-1)*100),2) as Percentage_Change from month_cte;

-- Peak Sales Period
select date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m') as Month, sum(total_amount) as Total_Sales
from orders 
group by date_format(str_to_date(order_date,'%Y-%m-%d'),'%Y-%m') 
order by Total_Sales desc
limit 3;


-- ORDER_DETAILS ANALYSIS
-- Inventory Refresh Rate
select product_id as Product_id, name as Product_Name, category as Category, count(*)as SalesFrequency, sum(quantity) as Total_Quantity, 
sum(quantity*price_per_unit) as Total_Revenue from order_details od inner join products p on p.ï»¿product_id=od.product_id
group by product_id, name, category
order by SalesFrequency desc
limit 5;

-- High Value Products
select product_id as Product_ID, name as Product_Name, category as Category, avg(quantity) as Avg_Quantity, 
sum(quantity*price_per_unit) as Total_Revenue 
from order_details od inner join products p on p.ï»¿product_id=od.product_id
group by product_id, name, category 
having avg(quantity)>=2
order by Avg_Quantity,Total_Revenue desc;




 