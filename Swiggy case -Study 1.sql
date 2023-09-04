SELECT * FROM swiggy.users;
use swiggy
select * from users;
select * from menu
select *  from order_details
select * from orders
select * from restaurants
select * from delivery_partner;
select * from food;

##--- Find customers who have never ordered from the restaurants #---

select name from users where user_id not in (select user_id from orders);

##--Average price dish for each food Items --##(Join type)

select f_id, avg(price) from menu group by f_id

select f.f_name, avg(price) as 'Avg_price' from menu m 
left join food f on m.f_id = f.f_id
group by m.f_id order by 'Avg_price'; 

##-- Find top restaurants in terms of no of orders for a given months ?#---

select *, monthname(date) as months from orders where monthname(date) like 'j_n%';

select r.r_name, count(*) as 'months' from
orders o join restaurants r on o.r_id = r.r_id 
where monthname(date) like 'june' 
group by o.r_id 
order by count(*) desc limit 1

 ##----Restaurant where monthly sales > x----
 
 select r.r_name, sum(amount) as revenue
 from orders o 
 join restaurants r
 on o.r_id = r.r_id
 where monthname(date) like 'june'
 group by o.r_id

##-- Show all orders with order details for a particular customer in a particular date Range ?---

select * from order_details

select o.order_id,r.r_name,f.f_id, f.f_name
from orders o
join restaurants r
on o.r_id = r.r_id 
join order_details od
on o.order_id = od.order_id
join food f
on od.f_id = f.f_id
where user_id = 
(select user_id from users where name = 'Ankit') and 
date > '2022-06-10' and date < '2022-07-10';

select * from food

##---Find restaurants with maximum repeated and loyal customers ---

select * from orders

select r.r_name,count(*) as 'Loyal_customer' from(
select user_id, r_id, count(*) as 'Visits' from orders 
group by user_id , r_id having Visits >1) t 
join restaurants r
on r.r_id = t.r_id
group by t.r_id
order by Loyal_customer desc limit 1;
			
select * from restaurants;

select * from orders;

##-- Month over month revenue growth of Swiggy ##----

select monthname(date) as month from orders;


select month, ((revenue - prev)/prev)*100 from (
    with sales as 
    (
          select sum(amount) as Total_revenue, monthname(date) as 'Months' 
          from orders where monthname(date) in ('june','july','May')
          group by Months
		  order by Months 
	)

		  select month,revenue,lag(revenue,1) over(order by revenue)  as prev from sales
) t

##--- Customer wise favourite Foods preferred from diferent restaurants ##----

select * from orders

select * from order_details

with temp as
(
     select o.user_id,od.f_id, count(*) as 'frequency' 
     from orders o
     join order_details od
     on o.order_id = od.order_id
     group by o.user_id,od.f_id 	
)

select u.name,f.f_name,t1.frequency
from temp t1 
join users u
on u.user_id = t1.user_id
join food f
on f.f_id = t1.f_id
where t1.frequency = (
   select max(frequency) 
   from temp t2 
   where t2.user_id = t1.user_id
)