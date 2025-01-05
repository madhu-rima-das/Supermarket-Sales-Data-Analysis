DROP TABLE IF EXISTS store_sales;

CREATE TABLE store_sales(
  Order_ID CHAR(14)
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
