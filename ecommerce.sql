CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE ecommerce_cart_items (
    id SERIAL NOT NULL primary key,
    physical_product_id integer,
    session_id char(36),
    order_id integer,
    created TIMESTAMP NOT NULL default CURRENT_TIMESTAMP,
    modified TIMESTAMP
);

CREATE TRIGGER update_ecommerce_cart_items_modtime BEFORE UPDATE ON ecommerce_cart_items FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
