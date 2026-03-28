CREATE TABLE dim_date (
    date_id DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    quarter INT,
    week_day VARCHAR(20)
);

CREATE TABLE dim_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE,
    pet_category VARCHAR(100)
);

CREATE TABLE dim_brand (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) UNIQUE
);

CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) UNIQUE,
    category_id INT REFERENCES dim_category(category_id),
    brand_id INT REFERENCES dim_brand(brand_id),
    price NUMERIC(10,2),
    weight NUMERIC(10,2),
    color VARCHAR(50),
    size VARCHAR(50),
    material VARCHAR(100),
    description TEXT,
    rating NUMERIC(3,1),
    reviews INT,
    release_date DATE,
    expiry_date DATE
);

CREATE TABLE dim_customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    age INT,
    country VARCHAR(100),
    postal_code VARCHAR(50),
    pet_type VARCHAR(50),
    pet_name VARCHAR(100),
    pet_breed VARCHAR(100)
);

CREATE TABLE dim_seller (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    country VARCHAR(100),
    postal_code VARCHAR(50)
);

CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(150) UNIQUE,
    location VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(150)
);

CREATE TABLE dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(150) UNIQUE,
    contact_person VARCHAR(150),
    email VARCHAR(150),
    phone VARCHAR(50),
    address VARCHAR(200),
    city VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date_id DATE REFERENCES dim_date(date_id),
    customer_id INT REFERENCES dim_customer(customer_id),
    seller_id INT REFERENCES dim_seller(seller_id),
    store_id INT REFERENCES dim_store(store_id),
    product_id INT REFERENCES dim_product(product_id),
    supplier_id INT REFERENCES dim_supplier(supplier_id),
    quantity INT,
    total_price NUMERIC(10,2)
);