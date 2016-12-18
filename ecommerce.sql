CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE ecommerce_orders (
    id SERIAL NOT NULL PRIMARY KEY,
    user_id INTEGER REFERENCES users,
    session_id CHAR(32),
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP,
    status VARCHAR(100),
    total DECIMNAL(12, 2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(12, 2) NOT NULL DEFAULT 0,
    tax DECIMAL(12, 2) NOT NULL DEFAULT 0,
    shipping DECIMAL(12, 2) NOT NULL DEFAULT 0,
    discount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    shipping_name,
    shipping_address_1
    shipping_address_2
    shipping_city
    shipping_state
    shipping_zipcode
    shipping_country
    billing_name,
    billing_address_1
    billing_address_2
    billing_city
    billing_state
    billing_zipcode
    billing_country
    deleted TIMESTAMP
);

CREATE TABLE ecommerce_product_categories (
    id SERIAL NOT NULL primary key,
    name VARCHAR(200) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP,
    deleted TIMESTAMP
);

CREATE TABLE ecommerce_products (
    id SERIAL NOT NULL primary key,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL,
    description TEXT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP,
    price_high DECIMAL,
    price_low DECIMAL,
    status VARCHAR(32),
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP,
    deleted TIMESTAMP
);

CREATE TABLE ecommerce_product_categories_map (
    id SERIAL NOT NULL primary key,
    category_id INTEGER NOT NULL REFERENCES ecommerce_product_categories,
    product_id INTEGER NOT NULL REFERENCES ecommerce_products,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ecommerce_products_physical (
    id SERIAL NOT NULL primary key,
    product_id INTEGER NOT NULL,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL,
    sku VARCHAR(100) NOT NULL,
    price DECIMNAL(12, 2),
    price_original DECIMNAL(12, 2),
    price_wholesale DECIMNAL(12, 2),
    status VARCHAR(32),
    sort_key SMALLINT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP,
    deleted TIMESTAMP
);

CREATE TABLE ecommerce_transactions (
    id SERIAL NOT NULL primary key,
    order_id INTEGER NOT NULL REFERENCES ecommerce_orders ON DELETE CASCADE,
    type VARCHAR(100) NOT NULL,
    amount DECIMNAL(12, 2) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted TIMESTAMP
);

CREATE TABLE ecommerce_sales_reps (
    id SERIAL NOT NULL primary key,
    user_id INTEGER NOT NULL REFERENCES users,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted TIMESTAMP
);

CREATE TABLE ecommerce_order_items (
    id SERIAL NOT NULL PRIMARY KEY,
    physical_product_id INTEGER NOT NULL REFERENCES ecommerce_products_physical,
    session_id CHAR(36) NOT NULL,
    order_id INTEGER,
    status VARCHAR(32) NOT NULL,
    price DECIMNAL(12, 2) NOT NULL,
    created TIMESTAMP NOT NULL default CURRENT_TIMESTAMP,
    modified TIMESTAMP,
    deleted TIMESTAMP
);

CREATE TRIGGER update_ecommerce_order_items_modtime BEFORE UPDATE ON ecommerce_order_items FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
