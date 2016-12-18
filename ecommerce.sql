CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE ecommerce_orders (
    id SERIAL NOT NULL primary key,
    user_id INTEGER,
    session_id CHAR(32),
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP,
    status VARCHAR(100),
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
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted TIMESTAMP
);

CREATE TABLE ecommerce_products_physical (
    id SERIAL NOT NULL primary key,
    product_id INTEGER NOT NULL,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL,
    sku VARCHAR(100) NOT NULL,
    price DECIMAL,
    price_original DECIMAL,
    price_wholesale DECIMAL,
    status VARCHAR(32),
    sort_key SMALLINT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP
);

CREATE TABLE ecommerce_transactions (
);

CREATE TABLE ecommerce_sales_reps ();



CREATE TABLE ecommerce_product_categories ();

CREATE TABLE ecommerce_order_items (
    id SERIAL NOT NULL primary key,
    physical_product_id integer,
    session_id char(36),
    order_id integer,
    created TIMESTAMP NOT NULL default CURRENT_TIMESTAMP,
    modified TIMESTAMP
);

CREATE TRIGGER update_ecommerce_order_items_modtime BEFORE UPDATE ON ecommerce_order_items FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
