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

--- load data which is in json format to global options
INSERT INTO global_options (value)
SELECT
    jsonb_extract(value, '$')
FROM json_each('
[
    {
        "name": "repeat log",
        "description": "Repeat a log output instead of compressing it",
        "type": "boolean",
        "flag": "loglevel",
        "support_no_prefix": false,
        "values": {
            "true": "repeat",
            "false": "-repeat"
        }
    },
    {
        "name": "prefix [level] log",
        "description": "Prefix [level] to each message line",
        "type": "boolean",
        "flag": "loglevel",
        "support_no_prefix": false,
        "values": {
            "true": "level",
            "false": "-level"
        }
    },
    {
        "name": "loglevel",
        "description": "Set logging level",
        "type": "string",
        "flag": "loglevel",
        "choices": [
            "quiet",
            "panic",
            "fatal",
            "error",
            "warning",
            "info",
            "verbose",
            "debug",
            "trace"
        ]
    },
    {
        "name": "report",
        "description": "Dump full command line and log output to a file",
        "type": "boolean",
        "flag": "report",
        "support_no_prefix": false
    },
    {
        "name": "hide banner",
        "description": "Suppress printing banner",
        "type": "boolean",
        "flag": "hide_banner",
        "support_no_prefix": false
    },
    {
        "name": "overwrite file",
        "description": "Overwrite output file without asking",
        "type": "boolean",
        "flag": "y",
        "support_no_prefix": false
    },
    {
        "name": "do not overwrite file",
        "description": "Do not overwrite output files, and exit immediately if a specified output file already exists.",
        "type": "boolean",
        "flag": "n",
        "support_no_prefix": false
    },
    {
        "name": "show stats",
        "description": "Print progress report during encoding",
        "type": "boolean",
        "flag": "stats",
        "support_no_prefix": true
    }
]
');
