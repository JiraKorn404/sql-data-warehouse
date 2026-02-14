DROP TABLE IF EXISTS bronze.olist_order_payment;
CREATE TABLE bronze.olist_order_payment (
	order_id VARCHAR(255),
    payment_sequential INT,
    payment_type VARCHAR(255),
    payment_installment INT,
    payment_value DECIMAL(10, 2)
);

DROP TABLE IF EXISTS bronze.olist_order_review;
CREATE TABLE bronze.olist_order_review (
	review_id VARCHAR(255),
    order_id VARCHAR(255),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message VARCHAR(255),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

DROP TABLE IF EXISTS bronze.olist_orders;
CREATE TABLE bronze.olist_orders (
	order_id VARCHAR(255),
    customer_id VARCHAR(255),
    order_status VARCHAR(255),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

DROP TABLE IF EXISTS bronze.olist_products;
CREATE TABLE bronze.olist_products (
	product_id VARCHAR(255),
    product_category_name VARCHAR(255),
    product_name_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_heigth_cm INT,
    product_width_cm INT
);

DROP TABLE IF EXISTS bronze.olist_sellers;
CREATE TABLE bronze.olist_sellers (
	seller_id VARCHAR(255),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(255),
    seller_state VARCHAR(255)
);

DROP TABLE IF EXISTS bronze.olist_product_category_name_translation;
CREATE TABLE bronze.olist_product_category_name_translation (
	product_category_name VARCHAR(255),
    product_category_name_englist VARCHAR(255)
);

DROP TABLE IF EXISTS bronze.olist_customers;
CREATE TABLE bronze.olist_customers(
	customer_id VARCHAR(255),
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(255),
    customer_state VARCHAR(255)
);

DROP TABLE IF EXISTS bronze.olist_geolocation;
CREATE TABLE bronze.olist_geolocation (
	geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10, 2),
    geolocation_lng DECIMAL(10, 2),
    geolocation_city VARCHAR(255),
    geolocation_state VARCHAR(255)
);

DROP TABLE IF EXISTS bronze.olist_order_items;
CREATE TABLE bronze.olist_order_items (
	order_id VARCHAR(255),
    order_item_id INT,
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date DATETIME,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2)
);
