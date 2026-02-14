TRUNCATE TABLE silver.olist_orders;
INSERT INTO silver.olist_orders (
SELECT
	TRIM(order_id) AS order_id,
    TRIM(customer_id) AS customer_id,
    LOWER(TRIM(order_status)) AS order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date AS order_delivered_customer_date,
    Date(order_estimated_delivery_date)
FROM bronze.olist_orders
);

TRUNCATE TABLE silver.olist_order_payments;
INSERT INTO silver.olist_order_payments (
SELECT
	TRIM(order_id) AS order_id,
    payment_sequential,
    LOWER(TRIM(payment_type)) AS payment_type,
    payment_installment,
    payment_value
FROM bronze.olist_order_payments
);

TRUNCATE TABLE silver.olist_order_reviews;
INSERT INTO silver.olist_order_reviews (
SELECT
	TRIM(review_id) AS review_id,
    TRIM(order_id) AS order_id,
    review_score,
    COALESCE(review_comment_title, 'n/a') AS review_comment_title,
    COALESCE(review_comment_message, 'n/a') AS reivew_comment_message,
	STR_TO_DATE(
		NULLIF(
			DATE_FORMAT(review_creation_date, '%Y-%m-%d %H:%i:%s'), '0000-00-00 00:00:00'
		), '%Y-%m-%d %H:%i:%s'
	) AS review_creation_date,
    STR_TO_DATE(
		NULLIF(
			DATE_FORMAT(review_answer_timestamp, '%Y-%m-%d %H:%i:%s'), '0000-00-00 00:00:00'
		), '%Y-%m-%d %H:%i:%s'
    ) AS review_answer_date
FROM bronze.olist_order_reviews
);

SELECT 
	TRIM(product_id) AS product_id,
    TRIM(product_category_name) AS product_category_name,
    product_description_length,
    product_name_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM bronze.olist_products
