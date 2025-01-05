create database superstore_sales;

use superstore_sales;


DROP TABLE IF EXISTS store_sales;

CREATE TABLE store_sales(
  Row_ID INT
  ,Order_ID CHAR(14)
  ,Order_Date DATE
  ,Ship_Date DATE
  ,Ship_Mode VARCHAR(15)
  ,Customer_ID CHAR(8)
  ,Customer_Name VARCHAR(50)
  ,Segment VARCHAR(20)
  ,Country VARCHAR(50)
  ,City VARCHAR(50)
  ,State VARCHAR(50)
  ,Postal_Code DOUBLE
  ,Region VARCHAR(10)
  ,Product_ID CHAR(15)
  ,Category VARCHAR(50)
  ,SubCategory VARCHAR(50)
  ,Product_Name VARCHAR(200)
  ,Sales DOUBLE
  ,Quantity DOUBLE
  ,Discount DOUBLE
  ,Profit DOUBLE
);



-- Data Cleaning

select * 
from store_sales;


select 
 count(*)
from store_sales;


select * 
from store_sales
where Order_ID is null;

select * 
from store_sales
where Row_ID is null
   	or Order_ID	is null
	or Order_Date is null
	or Ship_Date is null
	or Ship_Mode is null
	or Customer_ID is null
	or Customer_Name is null
	or Segment is null
	or Country is null
	or City is null
	or State is null
	or Postal_Code is null
	or Region is null
	or Product_ID is null
	or Category is null
	or SubCategory is null
	or Product_Name is null
	or Sales is null
	or Quantity is null
	or Discount is null
	or Profit is null
;

alter table store_sales
 drop column Row_ID;
 

delete from store_sales
where Row_ID is null
   	or Order_ID	is null
	or Order_Date is null
	or Ship_Date is null
	or Ship_Mode is null
	or Customer_ID is null
	or Customer_Name is null
	or Segment is null
	or Country is null
	or City is null
	or State is null
	or Postal_Code is null
	or Region is null
	or Product_ID is null
	or Category is null
	or SubCategory is null
	or Product_Name is null
	or Sales is null
	or Quantity is null
	or Discount is null
	or Profit is null
;

-- Data Exploration

-- length of dataset
select 
 count(*)
from store_sales;

-- how many years of data we have

select
 min(year(Order_Date)) as starting_year
 ,max(year(Order_Date)) as ending_year
 ,count(distinct year(Order_Date)) total_year
from store_sales
;

-- how many orders were placed 
select 
 count(distinct order_id)
from store_sales
;

-- how many products do we have
select 
 count(distinct Product_ID)
from store_sales
;

-- how many customers do we have
select 
 count(distinct Customer_ID)
from store_sales
;

-- total number of states we are delivering
select 
 count(distinct state)
from store_sales
;

-- number of city in each state
select 
 state
 ,count(distinct city)
from store_sales
group by state
;

-- categories of products
select distinct
 category
from store_sales
;

-- sub categories of products
select distinct
 SubCategory
from store_sales
;

-- different types of customer
select distinct
 Segment
from store_sales
;

-- types of shipping mode
select distinct
 Ship_Mode
from store_sales
;

-- name of the countries we have the informations for
select distinct
 Country
from store_sales
;
