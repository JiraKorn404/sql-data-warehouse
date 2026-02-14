-- Load Local File

LOAD DATA LOCAL INFILE 'C:/Users/korn1/Downloads/ecomerce olist/olist_order_payments_dataset.csv'
INTO TABLE bronze.olist_order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	order_id,
    @v_payment_sequential,
    @v_payment_type,
    @v_payment_installment,
    @v_payment_value
)
SET
	payment_sequential = NULLIF(@v_payment_sequential, ''),
    payment_type = NULLIF(@v_payment_type, ''),
    payment_installment = NULLIF(@v_payment_installment, ''),
    payment_value = NULLIF(@v_payment_value, '');

LOAD DATA LOCAL INFILE 'C:/Users/korn1/Downloads/ecomerce olist/olist_order_reviews_dataset.csv'
INTO TABLE bronze.olist_order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
	review_id,
    order_id,
    @v_review_score,
    @v_review_comment_title,
    @v_review_comment_message,
    @v_review_creation_date,
    @v_review_answer_timestamp
)
SET
	review_score = NULLIF(@v_review_score, ''),
    review_comment_title = NULLIF(@v_review_comment_title, ''),
    review_comment_message = NULLIF(@v_review_comment_message, ''),
    review_creation_date = NULLIF(@v_review_creation_date, ''),
    review_answer_timestamp = NULLIF(@v_review_answer_timestamp, '');

LOAD DATA LOCAL INFILE 'C:/Users/korn1/Downloads/ecomerce olist/olist_orders_dataset.csv'
INTO TABLE bronze.olist_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	order_id,
    customer_id,
    @v_order_status,
    @v_order_purchase_timestamp,
    @v_order_approved_at,
    @v_order_delivered_carrier_date,
    @v_order_delivered_customer_date,
    @v_order_estimated_delivery_date
)
SET
	order_status = NULLIF(@v_order_status, ''),
    order_purchase_timestamp = NULLIF(@v_order_purchase_timestamp, ''),
    order_approved_at = NULLIF(@v_order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(@v_order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(@v_order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(@v_order_estimated_delivery_date, '');

LOAD DATA LOCAL INFILE 'C:/Users/korn1/Downloads/ecomerce olist/olist_products_dataset.csv'
INTO TABLE bronze.olist_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	product_id,
    @v_product_category_name,
    @v_product_name_length,
    @v_product_description_length,
    @v_product_photos_qty,
    @v_product_weight_g,
    @v_product_length_cm,
    @v_product_heigth_cm,
    @v_product_width_cm
)
SET
	product_category_name = NULLIF(@v_product_category_name, ''),
    product_name_length = NULLIF(@v_product_name_length, ''),
    product_description_length = NULLIF(@v_product_description_length, ''),
    product_photos_qty = NULLIF(@v_product_photos_qty, ''),
    product_weight_g = NULLIF(@v_product_weight_g, ''),
    product_length_cm = NULLIF(@v_product_length_cm, ''),
    product_heigth_cm = NULLIF(@v_product_heigth_cm, ''),
    product_width_cm = NULLIF(@v_product_width_cm, '');

LOAD DATA LOCAL INFILE 'C:/Users/korn1/Downloads/ecomerce olist/olist_sellers_dataset.csv'
INTO TABLE bronze.olist_sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	seller_id,
    @v_seller_zip_code_prefix,
    @v_seller_city,
    @v_seller_state
)
SET
    seller_zip_code_prefix = NULLIF(@v_seller_zip_code_prefix, ''),
    seller_city = NULLIF(@v_seller_city, ''),
    seller_state = NULLIF(@v_seller_state, '');

LOAD DATA LOCAL INFILE 'C:/Users/korn1/Downloads/ecomerce olist/product_category_name_translation.csv'
INTO TABLE bronze.olist_product_category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	product_category_name,
    @v_product_category_name_english
)
SET
	product_category_name_english = NULLIF(@v_product_category_name_english, '');

LOAD DATA LOCAL INFILE 'C:/Users/korn1/Downloads/ecomerce olist/olist_customers_dataset.csv'
INTO TABLE bronze.olist_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	customer_id,
    customer_unique_id,
    @_vcustomer_zip_code_prefix,
    @_vcustomer_city,
    @_vcustomer_state
)
SET
    customer_zip_code_prefix = NULLIF(@v_customer_zip_code_prefix, ''),
    customer_city = NULLIF(@v_customer_city, ''),
    customer_state = NULLIF(@v_customer_state, '');

LOAD DATA LOCAL INFILE 'C:/Users/korn1/Downloads/ecomerce olist/olist_geolocation_dataset.csv'
INTO TABLE bronze.olist_geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	geolocation_zip_code_prefix,
    @v_geolocation_lat,
    @v_geolocation_lng,
    @v_geolocation_city,
    @v_geolocation_state
)
SET
	geolocation_lat = NULLIF(@v_geolocation_lat, ''),
    geolocation_lng = NULLIF(@v_geolocation_lng, ''),
    geolocation_city = NULLIF(@v_geolocation_city, ''),
    geolocation_state = NULLIF(@v_geolocation_state, '');

LOAD DATA LOCAL INFILE 'C:/Users/korn1/Downloads/ecomerce olist/olist_order_items_dataset.csv'
INTO TABLE bronze.olist_order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	order_id,
    order_item_id,
    product_id,
    seller_id,
    @v_shipping_limit_date,
    @v_price,
    @v_freight_value
)
SET
    shipping_limit_date = NULLIF(@v_shipping_limit_date, ''),
    price = NULLIF(@v_price, ''),
    freight_value = NULLIF(@v_freight_value, '');
