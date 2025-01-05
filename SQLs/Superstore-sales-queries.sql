-- ---------------------------------------- --
-- ---------------------------------------- --
-- - To use the database superstore_sales - --
-- ---------------------------------------- --
-- ---------------------------------------- --

USE superstore_sales;



-- ---------------- --
-- ---------------- --
-- - To read data - --
-- ---------------- --
-- ---------------- --

SELECT 
    *
FROM
    store_sales;



-- ----------------- --
-- ----------------- --
-- - To count data - --
-- ----------------- --
-- ----------------- --

SELECT 
    COUNT(*)
FROM
    store_sales;



-- -------------------------------------------------------- --
-- -------------------------------------------------------- --
-- - Which mode of shipment do customers prefer the most? - --
-- -------------------------------------------------------- --
-- -------------------------------------------------------- --

SELECT 
    ship_mode, COUNT(DISTINCT Customer_ID) AS Ship_mode_count
FROM
    store_sales
GROUP BY ship_mode
ORDER BY Ship_mode_count DESC
LIMIT 1;



-- ------------------------------------------------- --
-- ------------------------------------------------- --
-- - Segmemnt wise mostly ordered product category - --
-- ------------------------------------------------- --
-- ------------------------------------------------- --

select 
  Segment, 
  Category, 
  Order_Cnt 
from 
  (
    select 
      Segment, 
      Category, 
      Order_Cnt, 
      dense_rank() over (
        partition by Segment 
        order by 
          Order_Cnt desc
      ) dn 
    from 
      (
        select 
          Segment, 
          Category, 
          count(distinct order_ID) as Order_Cnt 
        from 
          store_sales 
        group by 
          Segment, 
          Category
      ) a
  ) b 
where 
  dn = 1;



-- ----------------------------------------------------------------------------- --
-- ----------------------------------------------------------------------------- --
-- - Display region wise number of orders placed, total sales and total profit - --
-- ----------------------------------------------------------------------------- --
-- ----------------------------------------------------------------------------- --

SELECT 
    region,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(SUM(sales), 2) total_sales,
    ROUND(SUM(profit), 2) total_profit
FROM
    store_sales
GROUP BY region
ORDER BY region;



-- ------------------------------------------- --
-- ------------------------------------------- --
-- - Display the number of states per region - --
-- ------------------------------------------- --
-- ------------------------------------------- --

SELECT 
    region, COUNT(DISTINCT state) no_of_states
FROM
    store_sales
GROUP BY region;



-- --------------------------------------------------------- --
-- --------------------------------------------------------- --
-- - percentage of quantity and total quantity region-wise - --
-- --------------------------------------------------------- --
-- --------------------------------------------------------- --

select 
  region, 
  category, 
  sum(quantity) as quantity_per_category, 
  round(
    (
      sum(quantity) * 100
    )/ total_quantity, 
    2
  ) as percentage_of_quantity 
FROM 
  (
    select 
      region, 
      category, 
      quantity, 
      sum(quantity) over(partition by region) as total_quantity 
    from 
      store_sales
  ) z 
group by 
  region, 
  category, 
  total_quantity 
order by 
  region, 
  category;



-- --------------------------------- --
-- --------------------------------- --
-- - product names which made loss - --
-- --------------------------------- --
-- --------------------------------- --

SELECT 
    Product_Name,
    ROUND(SUM(sales), 2) AS total_sale,
    SUM(quantity) AS total_quantity,
    ROUND(AVG(discount), 2) AS average_discount,
    ROUND(SUM(profit), 2) AS total_profit
FROM
    store_sales
GROUP BY Product_Name
HAVING total_profit < 0
ORDER BY total_profit;



-- ------------------------------------ --
-- ------------------------------------ --
-- - all the states which made profit - --
-- ------------------------------------ --
-- ------------------------------------ --

SELECT 
    state,
    COUNT(DISTINCT city) no_of_city,
    ROUND(SUM(sales), 2) AS total_sale,
    ROUND(SUM(profit), 2) AS total_profit
FROM
    store_sales
GROUP BY state
HAVING total_profit > 0
ORDER BY no_of_city DESC;



-- --------------------------------------------------------------------------------------------------------------------------------- --
-- --------------------------------------------------------------------------------------------------------------------------------- --
-- - Report the states, number of cities the orders came from, total sales and total profits per cities with negative total profit - --
-- --------------------------------------------------------------------------------------------------------------------------------- --
-- --------------------------------------------------------------------------------------------------------------------------------- --

SELECT 
    state,
    COUNT(DISTINCT city) no_of_city,
    ROUND(SUM(sales), 2) AS total_sale,
    ROUND(SUM(profit), 2) AS total_profit
FROM
    store_sales
GROUP BY state
HAVING total_profit < 0
ORDER BY no_of_city DESC;



-- ------------------------------------ --
-- ------------------------------------ --
-- - states with percentage of profit - --
-- ------------------------------------ --
-- ------------------------------------ --

SELECT 
    state,
    COUNT(DISTINCT city) no_of_city,
    ROUND(SUM(sales), 2) AS total_sale,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) * 100) / SUM(sales), 2) AS percentage_of_profit
FROM
    store_sales
GROUP BY state
ORDER BY no_of_city DESC;



-- ---------------------------------------------------------------------------------------------------------------------------- --
-- ---------------------------------------------------------------------------------------------------------------------------- --
-- - Report of number of distinct orders, total sales, total profit and %age of profit based on city with at least 30% profit - --
-- ---------------------------------------------------------------------------------------------------------------------------- --
-- ---------------------------------------------------------------------------------------------------------------------------- --

SELECT 
    city,
    COUNT(DISTINCT Order_ID) distinct_order,
    ROUND(SUM(sales), 2) AS total_sale,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) * 100) / SUM(sales), 2) AS percentage_of_profit
FROM
    store_sales
WHERE
    state = 'Texas'
GROUP BY city
HAVING percentage_of_profit >= 30
ORDER BY percentage_of_profit DESC;



-- -------------------------------------------------- --
-- -------------------------------------------------- --
-- - State wise distribution of number of customers - --
-- -------------------------------------------------- --
-- -------------------------------------------------- --

SELECT 
    state, COUNT(DISTINCT Customer_ID) AS no_of_customer
FROM
    store_sales
GROUP BY state
ORDER BY no_of_customer DESC;



-- ---------------------------------------------------------------------------- --
-- ---------------------------------------------------------------------------- --
-- - Report the state and city where the number of customers are more thn 100 - --
-- ---------------------------------------------------------------------------- --
-- ---------------------------------------------------------------------------- --

SELECT 
    state, city, COUNT(DISTINCT Customer_ID) AS no_of_customer
FROM
    store_sales
GROUP BY state , city
HAVING no_of_customer > 100
ORDER BY no_of_customer DESC;



-- ------------------------------------------------------------------------------------------------- --
-- ------------------------------------------------------------------------------------------------- --
-- - For each Shipping mode, what are the average days of product shipment from the date of order? - --
-- ------------------------------------------------------------------------------------------------- --
-- ------------------------------------------------------------------------------------------------- --

SELECT 
    Ship_Mode,
    MIN(DATEDIFF(Ship_Date, Order_Date)) min_days,
    MAX(DATEDIFF(Ship_Date, Order_Date)) max_days,
    ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)), 2) avg_days
FROM
    store_sales
GROUP BY ship_mode;



-- ---------------------------------------------------------------- --
-- ---------------------------------------------------------------- --
-- - segment wise number of customer, total sale and total profit - --
-- ---------------------------------------------------------------- --
-- ---------------------------------------------------------------- --

SELECT 
    segment,
    COUNT(DISTINCT Customer_ID) no_of_customer,
    ROUND(SUM(sales), 2) total_sale,
    ROUND(SUM(profit), 2) total_profit
FROM
    store_sales
GROUP BY segment;



-- --------------------------------------------------- --
-- --------------------------------------------------- --
-- - Top 10 most selling product throughout the year - --
-- --------------------------------------------------- --
-- --------------------------------------------------- --

SELECT 
    Product_Name,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(sales), 2) total_sale,
    ROUND(SUM(profit), 2) total_profit
FROM
    store_sales
GROUP BY Product_Name
ORDER BY total_quantity_sold DESC
LIMIT 10;



-- ---------------------------------- --
-- ---------------------------------- --
-- - Discount and loss distribution - --
-- ---------------------------------- --
-- ---------------------------------- --

SELECT 
    Discount,
    ROUND(SUM(sales), 2) total_sale,
    ROUND(SUM(profit), 2) total_profit
FROM
    store_sales
GROUP BY Discount
HAVING total_profit < 0
ORDER BY total_profit;



-- -------------------------------------------------------------------------- --
-- -------------------------------------------------------------------------- --
-- - Find out the customers who has placed orders in all the shipping modes - --
-- -------------------------------------------------------------------------- --
-- -------------------------------------------------------------------------- --

SELECT 
    Customer_ID, Customer_Name
FROM
    store_sales
GROUP BY Customer_ID , Customer_Name
HAVING COUNT(DISTINCT Ship_Mode) = (SELECT 
        COUNT(DISTINCT Ship_Mode)
    FROM
        store_sales);



-- --------------------------------------------------------------------------------------------------------------------------------------------- --
-- --------------------------------------------------------------------------------------------------------------------------------------------- --
-- - Find out the cities from which the orders are placed in all the years from 2014 to 2016 and display top 10 based on the total order count - --
-- --------------------------------------------------------------------------------------------------------------------------------------------- --
-- --------------------------------------------------------------------------------------------------------------------------------------------- --

SELECT 
    city,
    MAX(CASE
        WHEN yr = 2014 THEN orders
        ELSE NULL
    END) AS y_2014,
    MAX(CASE
        WHEN yr = 2015 THEN orders
        ELSE NULL
    END) AS y_2015,
    MAX(CASE
        WHEN yr = 2016 THEN orders
        ELSE NULL
    END) AS y_2016,
    SUM(orders) AS total_order
FROM
    (SELECT 
        city,
            YEAR(order_date) AS yr,
            COUNT(DISTINCT order_id) orders
    FROM
        store_sales
    WHERE
        YEAR(order_date) BETWEEN 2014 AND 2016
    GROUP BY city , YEAR(order_date)) a
GROUP BY city
HAVING y_2014 IS NOT NULL
    AND y_2015 IS NOT NULL
    AND y_2016 IS NOT NULL
ORDER BY total_order DESC
LIMIT 10;



-- ----------------------------------------------------------------------------- --
-- ----------------------------------------------------------------------------- --
-- - Which month of the year got maximum profitable orders? Most profit on top - --
-- ----------------------------------------------------------------------------- --
-- ----------------------------------------------------------------------------- --

SELECT 
    CASE EXTRACT(MONTH FROM Order_Date)
        WHEN 1 THEN 'Jan'
        WHEN 2 THEN 'Feb'
        WHEN 3 THEN 'Mar'
        WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'Jun'
        WHEN 7 THEN 'Jul'
        WHEN 8 THEN 'Aug'
        WHEN 9 THEN 'Sep'
        WHEN 10 THEN 'Oct'
        WHEN 11 THEN 'Nov'
        WHEN 12 THEN 'Dec'
    END AS order_month,
    ROUND(SUM(Profit), 2) AS total_profit
FROM
    store_sales
GROUP BY order_month
ORDER BY total_profit DESC;



-- ------------------------------------------------------------------------------------------------------------------------------- --
-- ------------------------------------------------------------------------------------------------------------------------------- --
-- - Publish the product sub-category and year wise total profit where the profit has been gradually increased from 2014 to 2017 - --
-- ------------------------------------------------------------------------------------------------------------------------------- --
-- ------------------------------------------------------------------------------------------------------------------------------- --

SELECT 
    SubCategory,
    MAX(CASE
        WHEN yr = 2014 THEN profit
        ELSE 0
    END) AS Year_2014,
    MAX(CASE
        WHEN yr = 2015 THEN profit
        ELSE 0
    END) AS Year_2015,
    MAX(CASE
        WHEN yr = 2016 THEN profit
        ELSE 0
    END) AS Year_2016,
    MAX(CASE
        WHEN yr = 2017 THEN profit
        ELSE 0
    END) AS Year_2017
FROM
    (SELECT 
        SubCategory,
            YEAR(Order_Date) AS yr,
            ROUND(SUM(profit), 2) AS profit
    FROM
        store_sales
    WHERE
        YEAR(Order_Date) BETWEEN 2014 AND 2017
    GROUP BY SubCategory , YEAR(Order_Date)) a
GROUP BY SubCategory
HAVING Year_2017 > Year_2016
    AND Year_2016 > Year_2015
    AND Year_2015 > Year_2014;



-- ------------------------------------------------ --
-- ------------------------------------------------ --
-- - Report product category, total sales in Q1-4 - --
-- ------------------------------------------------ --
-- ------------------------------------------------ --

SELECT 
    Category,
    MAX(CASE
        WHEN qtr = 1 THEN sales
        ELSE 0
    END) AS Q1,
    MAX(CASE
        WHEN qtr = 2 THEN sales
        ELSE 0
    END) AS Q2,
    MAX(CASE
        WHEN qtr = 3 THEN sales
        ELSE 0
    END) AS Q3,
    MAX(CASE
        WHEN qtr = 4 THEN sales
        ELSE 0
    END) AS Q4
FROM
    (SELECT 
        Category,
            QUARTER(Order_Date) AS qtr,
            ROUND(SUM(Sales), 2) AS sales
    FROM
        store_sales
    GROUP BY Category , qtr) a
GROUP BY Category;



-- ---------------------------------------------------------------------------------- --
-- ---------------------------------------------------------------------------------- --
-- - Report Customer ID and name who has only ordered in "First Class" shiping mode - --
-- ---------------------------------------------------------------------------------- --
-- ---------------------------------------------------------------------------------- --

SELECT 
  Customer_ID, 
  Customer_Name, 
  Ship_Mode 
FROM
  (
    SELECT 
      Customer_ID, 
      Customer_Name, 
      Ship_Mode, 
      COUNT(Ship_Mode) OVER (
        PARTITION BY Customer_ID, Customer_Name
      ) cnt 
    FROM
      (
        SELECT 
          DISTINCT Customer_ID, 
          Customer_Name, 
          Ship_Mode 
        FROM 
          store_sales
      ) a
  ) b 
WHERE 
  cnt = 1 
  AND Ship_Mode = 'First Class';



-- --------------------------------------------------------------------------------------------------- --
-- --------------------------------------------------------------------------------------------------- --
-- - Find out the city from which the customers order from all shipping mode except "Standard Class" - --
-- --------------------------------------------------------------------------------------------------- --
-- --------------------------------------------------------------------------------------------------- --

SELECT 
  City, 
  Ship_Mode, 
  std_cls_present, 
  Ship_Mode_Cnt_xcpt_std_cls, 
  Ship_Mode_Cnt 
FROM 
  (
    SELECT 
      City, 
      Ship_Mode, 
      SUM(
        CASE WHEN Ship_Mode = 'Standard Class' THEN 1 ELSE 0 END
      ) OVER (PARTITION BY City) AS std_cls_present, 
      COUNT(Ship_Mode) OVER (PARTITION BY City) AS Ship_Mode_Cnt_xcpt_std_cls, 
      Ship_Mode_Cnt 
    FROM 
      (
        SELECT 
          DISTINCT city, 
          Ship_Mode, 
          (
            SELECT 
              COUNT(DISTINCT Ship_Mode) 
            FROM 
              store_sales
          ) Ship_Mode_Cnt 
        FROM 
          store_sales
      ) a
  ) b 
WHERE 
  std_cls_present = 0 
  AND Ship_Mode_Cnt_xcpt_std_cls + 1 = Ship_Mode_Cnt;



-- ----------------------------------------------------- --
-- ----------------------------------------------------- --
-- - Most selling product in each city (quantity wise) - --
-- ----------------------------------------------------- --
-- ----------------------------------------------------- --

SELECT 
  city, 
  Product_Name, 
  qty 
FROM 
  (
    SELECT 
      city, 
      Product_Name, 
      qty, 
      DENSE_RANK() OVER(
        PARTITION BY city 
        ORDER BY 
          qty DESC
      ) AS rnk 
    FROM 
      (
        SELECT 
          city, 
          Product_Name, 
          SUM(quantity) AS qty 
        FROM 
          store_sales 
        GROUP BY 
          1, 
          2
      ) z
  ) s 
WHERE 
  rnk = 1;



-- ------------------------------------------ --
-- ------------------------------------------ --
-- - Total sell of every month of each year - --
-- ------------------------------------------ --
-- ------------------------------------------ --

SELECT 
    order_month,
    MAX(CASE
        WHEN yr = 2014 THEN total_profit
        ELSE 0
    END) AS Year_2014,
    MAX(CASE
        WHEN yr = 2015 THEN total_profit
        ELSE 0
    END) AS Year_2015,
    MAX(CASE
        WHEN yr = 2016 THEN total_profit
        ELSE 0
    END) AS Year_2016,
    MAX(CASE
        WHEN yr = 2017 THEN total_profit
        ELSE 0
    END) AS Year_2017
FROM
    (SELECT 
        CASE EXTRACT(MONTH FROM Order_Date)
                WHEN 1 THEN 'Jan'
                WHEN 2 THEN 'Feb'
                WHEN 3 THEN 'Mar'
                WHEN 4 THEN 'Apr'
                WHEN 5 THEN 'May'
                WHEN 6 THEN 'Jun'
                WHEN 7 THEN 'Jul'
                WHEN 8 THEN 'Aug'
                WHEN 9 THEN 'Sep'
                WHEN 10 THEN 'Oct'
                WHEN 11 THEN 'Nov'
                WHEN 12 THEN 'Dec'
            END AS order_month,
            YEAR(Order_Date) AS yr,
            ROUND(SUM(Profit), 2) AS total_profit
    FROM
        store_sales
    GROUP BY order_month , yr) a
GROUP BY order_month
ORDER BY order_month;

