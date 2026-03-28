INSERT INTO dim_date (date_id, year, month, day, quarter, week_day)
SELECT DISTINCT 
    TO_DATE(sale_date, 'MM/DD/YYYY') as date_id,
    EXTRACT(YEAR FROM TO_DATE(sale_date, 'MM/DD/YYYY'))::INT as year,
    EXTRACT(MONTH FROM TO_DATE(sale_date, 'MM/DD/YYYY'))::INT as month,
    EXTRACT(DAY FROM TO_DATE(sale_date, 'MM/DD/YYYY'))::INT as day,
    EXTRACT(QUARTER FROM TO_DATE(sale_date, 'MM/DD/YYYY'))::INT as quarter,
    INITCAP(TO_CHAR(TO_DATE(sale_date, 'MM/DD/YYYY'), 'Day')) as week_day
FROM mock_data
WHERE sale_date IS NOT NULL
ON CONFLICT (date_id) DO NOTHING;

INSERT INTO dim_category (category_name, pet_category)
SELECT DISTINCT product_category, pet_category
FROM mock_data
WHERE product_category IS NOT NULL
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO dim_brand (brand_name)
SELECT DISTINCT product_brand
FROM mock_data
WHERE product_brand IS NOT NULL
ON CONFLICT (brand_name) DO NOTHING;

INSERT INTO dim_product (
    product_name, category_id, brand_id, price, weight, 
    color, size, material, description, rating, reviews, 
    release_date, expiry_date
)
SELECT DISTINCT 
    m.product_name,
    c.category_id,
    b.brand_id,
    m.product_price::NUMERIC(10,2),
    m.product_weight::NUMERIC(10,2),
    m.product_color,
    m.product_size,
    m.product_material,
    m.product_description,
    m.product_rating::NUMERIC(3,1),
    m.product_reviews::INT,
    TO_DATE(m.product_release_date, 'MM/DD/YYYY'),
    TO_DATE(m.product_expiry_date, 'MM/DD/YYYY')
FROM mock_data m
LEFT JOIN dim_category c ON c.category_name = m.product_category
LEFT JOIN dim_brand b ON b.brand_name = m.product_brand
WHERE m.product_name IS NOT NULL
ON CONFLICT (product_name) DO NOTHING;

INSERT INTO dim_customer (
    first_name, last_name, email, age, country, 
    postal_code, pet_type, pet_name, pet_breed
)
SELECT DISTINCT 
    customer_first_name, 
    customer_last_name, 
    customer_email, 
    customer_age::INT,
    customer_country, 
    customer_postal_code, 
    customer_pet_type, 
    customer_pet_name, 
    customer_pet_breed
FROM mock_data
WHERE customer_email IS NOT NULL
ON CONFLICT (email) DO NOTHING;

INSERT INTO dim_seller (first_name, last_name, email, country, postal_code)
SELECT DISTINCT 
    seller_first_name, 
    seller_last_name, 
    seller_email, 
    seller_country, 
    seller_postal_code
FROM mock_data
WHERE seller_email IS NOT NULL
ON CONFLICT (email) DO NOTHING;

INSERT INTO dim_store (
    store_name, location, city, state, country, phone, email
)
SELECT DISTINCT 
    store_name, 
    store_location, 
    store_city, 
    store_state, 
    store_country, 
    store_phone, 
    store_email
FROM mock_data
WHERE store_name IS NOT NULL
ON CONFLICT (store_name) DO NOTHING;

INSERT INTO dim_supplier (
    supplier_name, contact_person, email, phone, address, city, country
)
SELECT DISTINCT 
    supplier_name, 
    supplier_contact, 
    supplier_email, 
    supplier_phone,
    supplier_address, 
    supplier_city, 
    supplier_country
FROM mock_data
WHERE supplier_name IS NOT NULL
ON CONFLICT (supplier_name) DO NOTHING;

INSERT INTO fact_sales (
    sale_date_id, customer_id, seller_id, store_id, 
    product_id, supplier_id, quantity, total_price
)
SELECT 
    TO_DATE(m.sale_date, 'MM/DD/YYYY') as sale_date_id,
    c.customer_id,
    s.seller_id,
    st.store_id,
    p.product_id,
    sup.supplier_id,
    m.sale_quantity::INT,
    (m.sale_quantity::INT * p.price)::NUMERIC(10,2) as total_price
FROM mock_data m
LEFT JOIN dim_customer c ON c.email = m.customer_email
LEFT JOIN dim_seller s ON s.email = m.seller_email
LEFT JOIN dim_store st ON st.store_name = m.store_name
LEFT JOIN dim_product p ON p.product_name = m.product_name
LEFT JOIN dim_supplier sup ON sup.supplier_name = m.supplier_name
WHERE m.sale_date IS NOT NULL AND m.sale_quantity IS NOT NULL;

SELECT 
    'dim_customer' as table_name, COUNT(*) as row_count FROM dim_customer
UNION ALL
SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL
SELECT 'dim_category', COUNT(*) FROM dim_category
UNION ALL
SELECT 'dim_brand', COUNT(*) FROM dim_brand
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_seller', COUNT(*) FROM dim_seller
UNION ALL
SELECT 'dim_store', COUNT(*) FROM dim_store
UNION ALL
SELECT 'dim_supplier', COUNT(*) FROM dim_supplier
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM fact_sales
ORDER BY table_name;