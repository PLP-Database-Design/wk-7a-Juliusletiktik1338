CREATE TABLE OrderProducts_1NF AS
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.digit+1), ',', -1)) AS Product
FROM 
    ProductDetail
JOIN 
    (SELECT 0 AS digit UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) n
    ON LENGTH(REPLACE(Products, ',', '')) <= LENGTH(Products) - n.digit
WHERE
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.digit+1), ',', -1)) != ''
ORDER BY
    OrderID;
-- First, create the Orders table (removing the partial dependency)
CREATE TABLE Orders_2NF AS
SELECT DISTINCT
    OrderID,
    CustomerName
FROM 
    OrderDetails;

-- Then create the OrderItems table with the full dependency
CREATE TABLE OrderItems_2NF AS
SELECT 
    OrderID,
    Product,
    Quantity
FROM 
    OrderDetails;

-- Add primary keys
ALTER TABLE Orders_2NF ADD PRIMARY KEY (OrderID);
ALTER TABLE OrderItems_2NF ADD PRIMARY KEY (OrderID, Product);
