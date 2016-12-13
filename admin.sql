CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE admin_widgets (
    id SERIAL NOT NULL primary key,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    link VARCHAR(250),
    call_to_action varchar(100),
    type varchar(100),
    role_ids INTEGER[],
    created TIMESTAMP NOT NULL default CURRENT_TIMESTAMP,
    modified TIMESTAMP
);

CREATE TRIGGER update_widget_modtime BEFORE UPDATE ON widgets FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
