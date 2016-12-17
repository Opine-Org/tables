CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE ecommerce_orders ();

CREATE TABLE ecommerce_transactions ();

CREATE TABLE ecommerce_sales_reps ();

CREATE TABLE ecommerce_customers ();

CREATE TABLE ecommerce_product_categories ();

CREATE TABLE ecommerce_products_logical ();

CREATE TABLE ecommerce_products_physical ();

CREATE TABLE ecommerce_order_items (
    id SERIAL NOT NULL primary key,
    physical_product_id integer,
    session_id char(36),
    order_id integer,
    created TIMESTAMP NOT NULL default CURRENT_TIMESTAMP,
    modified TIMESTAMP
);

CREATE TRIGGER update_ecommerce_order_items_modtime BEFORE UPDATE ON ecommerce_order_items FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
