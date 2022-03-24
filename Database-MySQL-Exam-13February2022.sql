--01. Table Design
CREATE TABLE brands(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE categories(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE reviews(
id INT AUTO_INCREMENT PRIMARY KEY,
content TEXT,
rating DECIMAL(10, 2) NOT NULL,
picture_url VARCHAR(80) NOT NULL,
published_at DATETIME NOT NULL
);

CREATE TABLE products (
id INT AUTO_INCREMENT PRIMARY KEY, 
name VARCHAR(40) NOT NULL, 
price DECIMAL(19, 2) NOT NULL,
quantity_in_stock INT, 
description TEXT,
brand_id INT NOT NULL,
category_id INT NOT NULL,
review_id INT, 
CONSTRAINT fk_products_brands
FOREIGN KEY (brand_id) REFERENCES brands(id), 
CONSTRAINT fk_products_categories
FOREIGN KEY (category_id) REFERENCES categories(id), 
CONSTRAINT fk_products_reviews 
FOREIGN KEY (review_id) REFERENCES reviews(id)
);

CREATE TABLE customers (
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
phone VARCHAR(30) UNIQUE NOT NULL,
address VARCHAR(60) NOT NULL,
discount_card BIT(1) NOT NULL DEFAULT 0
);

CREATE TABLE orders(
id INT AUTO_INCREMENT PRIMARY KEY,
order_datetime DATETIME NOT NULL, 
customer_id INT NOT NULL,
CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE orders_products(
order_id INT, 
product_id INT,
CONSTRAINT fk_orders_product
FOREIGN KEY (order_id) REFERENCES orders(id),
CONSTRAINT fk_product_orders
FOREIGN KEY (product_id) REFERENCES products(id)
);

--02. Insert
INSERT INTO reviews(content, picture_url, published_at, rating)
SELECT SUBSTRING(p.description FROM 1 FOR 15), reverse(p.name), 
'2010-10-10' as published_at,
(p.price/8) AS rating
FROM products p
WHERE p.id >= 5;

--03. Update
UPDATE products
SET quantity_in_stock = (quantity_in_stock - 5)
WHERE quantity_in_stock >= 60 AND quantity_in_stock <= 70; 

--04. Delete
DELETE FROM customers c
WHERE c.id NOT IN(SELECT customer_id FROM orders);

--05. Categories
SELECT id, name FROM categories
ORDER BY name DESC;

--06. Quantity
SELECT id, brand_id, name, quantity_in_stock
FROM products
WHERE price > 1000 AND quantity_in_stock < 30
ORDER BY quantity_in_stock, id; 

--07. Review
SELECT id, content, rating, picture_url, published_at
FROM reviews 
WHERE char_length(content) > 61 AND SUBSTRING(content FROM 1 FOR 2) = 'My'
ORDER BY rating DESC;

--08. First customers
SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name, 
c.address, o.order_datetime FROM customers c 
JOIN orders o ON(o.customer_id = c.id)
WHERE YEAR(o.order_datetime) <= 2018
ORDER BY full_name DESC;

--09. Best categories
SELECT COUNT(p.id) AS items_count, 
c.name, SUM(p.quantity_in_stock) AS total_quantity FROM categories c
JOIN products p ON c.id = p.category_id
GROUP BY c.id
ORDER BY items_count DESC, total_quantity
LIMIT 5;

--10. Extract client cards count
CREATE FUNCTION udf_customer_products_count(name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN 
RETURN (SELECT COUNT(o.id) AS total_products
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN orders_products op ON o.id = op.order_id
JOIN products p ON p.id = op.product_id
GROUP BY c.first_name
HAVING c.first_name = name);
END

--11. Reduce price
CREATE PROCEDURE udp_reduce_price (category_name VARCHAR(50)) 
BEGIN 
UPDATE products pr
JOIN categories c ON (c.id = pr.category_id)
JOIN reviews r ON (r.id = pr.review_id)
SET price = price - (price * 0.3)
WHERE c.name = category_name AND r.rating < 4;
END

--
