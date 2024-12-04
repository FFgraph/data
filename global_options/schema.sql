-- Create global options table and generated fields
CREATE TABLE global_options (
    value JSONB NOT NULL,
    name TEXT AS (jsonb_extract(value, '$.name')) STORED,
    description TEXT AS (jsonb_extract(value, '$.description')) STORED,
    type TEXT AS (jsonb_extract(value, '$.type')) STORED,
    flag TEXT AS (jsonb_extract(value, '$.flag')) STORED
);

--- create unique index for name field
CREATE UNIQUE INDEX global_options_name ON global_options(name);

--- create index for flag field
CREATE INDEX global_options_flag ON global_options(flag);

--- load data.json file which contains all json
INSERT INTO global_options (value)
SELECT
    jsonb_extract(value, '$')
FROM json_each(readfile('data.json'));
