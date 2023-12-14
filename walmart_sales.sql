create database if not exists salesdataWalmart; 

create table if not exists sales(
   invoice_id varchar(30) not null primary key,
   branch varchar(5) not null,
   city varchar(30) not null,
   customer_type varchar(30) not null,
   gender varchar(10) not null,
   product_line varchar(100) not null,
   unit_price decimal(10) not null,
   quantity int not null,
   VAT float(6,4) not null,
   total decimal(12,4) not null,
   date DATETIME not null,
   time TIME not null,
   payment_method varchar(15) not null,
   cogs decimal(10,2) not null,
   gross_margin_pct float(11,9),
   gross_income decimal(12,4) not null,
   rating float(2,1)
   
   
   
);

select * from salesdatawalmart.sales;

-- ---------------------------------------------------------------------------
-- -------------------Feature Engineering - will help to generate new columns 

-- 1. add column time_of_day
select
 time,
 (
 case
 when `time` between "00:00:00" and "12:00:00" then "morning"
 when `time` between "12:01:00" and "16:00:00" then "afternoon"
 else "evening"
 
 end
 )as time_of_date
from sales;

alter table sales add column time_of_day varchar(20);
update sales 
set time_of_day = (
case
 when `time` between "00:00:00" and "12:00:00" then "morning"
 when `time` between "12:01:00" and "16:00:00" then "afternoon"
 else "evening"
 
 end
);

-- 2. add column day_name

select 
  date,
  dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);
update sales
set day_name = dayname(date);


-- 3. add column month_name

select 
date,
monthname(date) as month_name
from sales;

alter table sales add column month_name varchar(10);
update sales
set month_name = monthname(date);

-- -------------------------------------------------------------

-- --------------------------------------------------------------
-- -----------------generic questions -------------------------------

-- 1. unique cities data have
select 
distinct city
from sales;

-- 2.unique branchs and city respectively
select 
distinct branch
from sales;

select distinct city,
branch
from sales;

-- --------------------product questions-----------

-- 1. How many unique product lines does the data have?

select 
count(distinct product_line)
from sales;

-- 2.What is the most common payment method?
select
 payment_method,count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc; 

-- 3.What is the most selling product line?
select
 product_line,count(product_line) as cnt2
from sales
group by product_line
order by cnt2 desc; 

-- 4.What is the total revenue by month?
select month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- 5.What month had the largest COGS?
select 
month_name as month,
sum(cogs) as cogs 
from sales
group by month_name
order by cogs;
-- 6.What product line had the largest revenue?
select
product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue;

-- 7.What is the city with the largest revenue?
select 
city,branch,
sum(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc;
-- 8.What product line had the largest VAT?
select 
product_line,
avg(vat) as avg_tax
from sales
group by product_line
order by avg_tax;

-- 10.Which branch sold more products than average product sold?
select 
branch,
sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quatity) from sales) ;




