create database ecommerce;
use ecommerce;

ALTER TABLE olist_orders
CHANGE COLUMN `ï»¿order_id` `order_id` VARCHAR(255);

ALTER TABLE olist_orders_payements
CHANGE COLUMN `ï»¿order_id` `order_id` VARCHAR(255);

ALTER TABLE olist_products
CHANGE COLUMN `ï»¿product_id` `product_id` VARCHAR(255);

ALTER TABLE olist_order_items
CHANGE COLUMN `ï»¿order_id` `order_id` VARCHAR(255);

ALTER TABLE olist_customers
CHANGE COLUMN `ï»¿customer_id` `customer_id` VARCHAR(255);

ALTER TABLE olist_orders
CHANGE COLUMN `Shipping Days` `ShippingDays` VARCHAR(255);

ALTER TABLE olist_orders
CHANGE COLUMN `Weekday/Weekend` `DayType` VARCHAR(255);

# 1 - KPI
#weekday vs weekend (order_purchase_timestamp) Payment statistics

SELECT 
    DayType,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    ROUND(SUM(p.payment_value), 2) AS TotalPayments,
    ROUND(AVG(p.payment_value), 2) AS AveragePayment
FROM 
    olist_orders o
JOIN 
    olist_orders_payements p 
ON 
    o.order_id = p.order_id
GROUP BY 
    DayType;


# KPI - 2: Number Of Orders with review score 5 and payment type as credit card.

SELECT 
    COUNT(pmt.order_id) AS Total_orders
FROM
    olist_orders_payements pmt
        INNER JOIN
    olist_orders_reviews rev ON pmt.order_id = rev.order_id
WHERE
    rev.review_score = 5
        AND pmt.payment_type = 'credit_card';
        

# KPI -3 :Average number of days taken for order_delivered_customer_date for pet_shop

SELECT 
    p.Product_Category_Name,
    ROUND(AVG(Days), 2) AS avg_delivery_time
FROM 
    olist_orders o
JOIN 
    olist_order_items i ON i.order_id = o.order_id
JOIN 
    olist_products p ON p.product_id = i.product_id
WHERE 
    p.Product_Category_Name = 'pet_shop'
    AND Days IS NOT NULL;
    
    
#KPI -4 :Average price and payment values from customers of sao paulo city

SELECT 
    ROUND(AVG(i.Price), 2) AS average_price,
    ROUND(AVG(p.Payment_value), 2) AS average_payment
FROM 
    olist_customers c
JOIN 
    olist_orders o ON c.Customer_id = o.Customer_id
JOIN 
    olist_order_items i ON o.Order_id = i.Order_id
JOIN 
    olist_orders_payements p ON o.Order_id = p.Order_id
WHERE 
    customer_city = 'Sao Paulo';
    
#KPI -5 Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT 
    ROUND(AVG(ShippingDays), 0) AS AvgShippingDays,
    Review_Score
FROM 
    olist_orders o
JOIN 
    olist_orders_reviews r ON o.Order_id = r.Order_id
WHERE 
    ShippingDays IS NOT NULL
    AND ShippingDays >= 0
GROUP BY 
    Review_Score;