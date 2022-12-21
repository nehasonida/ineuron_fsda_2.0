---- 1. Load the given dataset into snowflake with a primary key to Order Date column.

CREATE OR REPLACE TABLE NS_SALES_DATA
(
 Order_ID STRING,
 Order_Date STRING PRIMARY KEY,
 Ship_Date STRING,
 Ship_Mode VARCHAR(100),
 Customer_Name VARCHAR(100),	
 Segment VARCHAR(100),
 State VARCHAR(100),
 Country_Region VARCHAR(100),
 Market VARCHAR(80),
 Region VARCHAR(100),
 Product_ID	STRING,
 Category VARCHAR(100),
 Subcategory VARCHAR(100),
 Product_Name STRING(300),
 Sales FLOAT(100),
 Quantity NUMBER(20,0),	
 Discount FLOAT(100),
 Profit FLOAT(100),
 Shipping_Cost FLOAT(100),
 Order_priority VARCHAR(50),
 year STRING
);

DESCRIBE TABLE NS_SALES_DATA;
SELECT * FROM NS_SALES_DATA; 


----  2. Change the Primary key to Order Id Column.

ALTER TABLE NS_SALES_DATA
DROP PRIMARY KEY;

ALTER TABLE NS_SALES_DATA
ADD PRIMARY KEY (Order_ID);


----  3. Check the data type for Order date and Ship date and mention in what data type it should be?
----     // Done in Excel sheet while data cleaning.//


----  4. Create a new column called order_extract and extract the number after the last ‘–‘from Order ID column.

ALTER TABLE NS_SALES_DATA
ADD COLUMN order_extract VARCHAR(60); 

UPDATE NS_SALES_DATA
SET order_extract = SPLIT_PART(Order_ID,'-',3);


----  5. Create a new column called Discount Flag and categorize it based on discount. Use ‘Yes’ if the discount is greater than zero else ‘No’.

ALTER TABLE NS_SALES_DATA
ADD COLUMN Discount_Flag VARCHAR(5); 

UPDATE NS_SALES_DATA
SET Discount_Flag = CASE WHEN Discount>0 THEN 'Yes'
                         ELSE 'No'
                    END;


----  6. Create a new column called process days and calculate how many days it takes for each order id to process from the order to its shipment.

ALTER TABLE NS_SALES_DATA
ADD COLUMN process_days INT;

UPDATE NS_SALES_DATA
SET process_days = DATEDIFF('DAY',Order_Date,Ship_Date);


----  7. Create a new column called Rating and then based on the Process dates give
-- rating like given below.
-- a. If process days less than or equal to 3days then rating should be 5
-- b. If process days are greater than 3 and less than or equal to 6 then rating should be 4
-- c. If process days are greater than 6 and less than or equal to 10 then rating should be 3
-- d. If process days are greater than 10 then the rating should be 2.

ALTER TABLE NS_SALES_DATA
ADD COLUMN RATING INT;

UPDATE NS_SALES_DATA
SET RATING = 
CASE 
 WHEN process_days <=3 THEN 5
 WHEN process_days BETWEEN 4 AND 6 THEN 4
 WHEN process_days BETWEEN 7 AND 10 THEN 3
 ELSE 2
END;


---- FINAL TABLE
SELECT * FROM NS_SALES_DATA;