SELECT * FROM customers

-------Removing Duplicate from the customer table
WITH Duplicated AS (
	SELECT DISTINCT ON (customer_id) *
	FROM customers c
	ORDER BY customer_id
)

DELETE FROM customers c
WHERE c.customer_id NOT IN ( SELECT customer_id FROM Duplicated)

----Checking for Nulls Row
SELECT * 
FROM customers
WHERE region IS NULL

-----Set Null values to be Unknown
SELECT customer_id, contact_name, COALESCE(Region, 'Unknown') AS Region
FROM customers

---Analyse the impact of Nulls
SELECT country, COUNT(*) AS TotalCustomers, COUNT(region) CustomersWithRegion, COUNT(*)-COUNT(region) AS CustomersWithnoRegion
FROM Customers
GROUP BY Country

----------------------------------------------------------------------------------------------------------------------
----Exploratory Data Analysis
--------1: write a query to get Product name and quantity/unit.

SELECT product_name, quantity_per_unit
FROM products

--------2: Write a query to get current Product list (Product ID and name).
SELECT product_id, product_name
FROM products

--------3: Write a query to get the Products by Category
SELECT c.category_name,p. product_name
FROM products p
JOIN categories c ON c.category_id = p.category_id 

--------4: Write a query to get discontinued Product list (Product ID and name).
SELECT product_id, product_name
FROM products
WHERE discontinued = 1

-------5:Write a query to get most expense and least expensive Product list (name and unit price).
(SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 1)

UNION 

(SELECT product_name, unit_price
FROM products
ORDER BY unit_price ASC
LIMIT 1)


-------6:Write a query to get Product list (id, name, unit price) where current products cost less than $20.
SELECT product_id, product_name,unit_price
FROM products
WHERE unit_price < '20' AND discontinued = 0

-------7:Write a query to get Product list (id, name, unit price) where products cost between $15 and $25.

SELECT product_id, product_name,unit_price
FROM products
WHERE unit_price BETWEEN '15' AND '25'

-------8:Write a query to get Product list (name, unit price) of above average price.
SELECT product_name, unit_price, AVG(unit_price)
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products)
GROUP BY product_name, unit_price
ORDER BY AVG(unit_price);

-----9:Write a query to get Product list (name, unit price) of ten most expensive products.
SELECT product_name,unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10

-------10:Write a query to count current and discontinued products.

SELECT
			COUNT(CASE WHEN discontinued = 0 THEN 1 END) AS current_products,
			COUNT(CASE WHEN discontinued = 1 THEN 1 END) AS discontinued_products
FROM products;

-------11:Write a query to get Product list (name, units on order , units in stock) of stock is less than the quantity on order.
SELECT product_name,units_on_order, units_in_stock
FROM products
WHERE units_in_stock < units_on_order

-------12:For each employee, get their sales amount.
SELECT e.employee_id,e.first_name,e.last_name, SUM(od.quantity * od.unit_price *( 1-od.discount)) AS Total_Sales_amount
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY e.employee_id,e.first_name,e.last_name
ORDER BY Total_Sales_amount DESC;

------13. Write a query that returns the order and calculates sales price for each order after discount is applied
SELECT o.order_id, SUM(od.quantity * od.unit_price *( 1-od.discount)) AS Total_Sales_Price
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY Total_Sales_Price DESC;

------14. For each category, get the list of products sold and the total sales amount per product
SELECT c. category_name,p.product_name, SUM(od.quantity * od.unit_price *( 1-od.discount)) AS Total_Sales_Amount
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_details od ON od.product_id = p.product_id
GROUP BY c. category_name,p.product_name
ORDER BY Total_Sales_Amount DESC

------Write a query that shows sales figures by categories for the year 1997 alone.
SELECT c. category_name,SUM(od.quantity * od.unit_price *( 1-od.discount)) AS Total_Sales_Amount
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_details od ON od.product_id = p.product_id
JOIN orders o ON o.order_id = od.order_id
WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-30'
GROUP BY c. category_name
ORDER BY Total_Sales_Amount DESC;



