CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE content_sections (
    id serial not null primary key,
    code varchar(32),
    description text,
    data jsonb,
    author integer NOT NULL references users,
    created timestamp NOT NULL default CURRENT_TIMESTAMP,
    modified timestamp,
    deleted boolean default 'f',
    activity varchar(100)
);

CREATE TRIGGER update_content_sections_modtime BEFORE UPDATE ON content_sections FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

CREATE TABLE content (
    id serial not null primary key,
    slug varchar(200) not null,
    title varchar(200) not null,
    section varchar(32),
    published boolean default 'f', 
    data jsonb,
    author integer NOT NULL references users,
    created timestamp NOT NULL default CURRENT_TIMESTAMP,
    modified timestamp,
    deleted boolean default 'f',
    activity varchar(100)
);

CREATE TRIGGER update_content_modtime BEFORE UPDATE ON content FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

-- TODO: create trigger to populate versions table on each UPDATE

CREATE TABLE content_versions (
    id serial not null primary key,
    slug varchar(200) not null,
    title varchar(200) not null,
    section varchar(32),
    published boolean default 'f', 
    data jsonb,
    created timestamp NOT NULL default CURRENT_TIMESTAMP,
    author integer NOT NULL references users,
    modified timestamp,
    deleted boolean default 'f',
    activity varchar(100)
);
