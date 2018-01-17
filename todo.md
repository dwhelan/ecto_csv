# EctoCSV
* handle header row with blank cells (allow code to specify name or field number)
* rename to EctoCSV
* loader
    * handle an "id" key
    * load!
    * file with headers - validate they match schema? use to map, missing, extra
    * auto generate schema fields from header - create `mix csv.create_schema <file>` 
    * import with no schema -> create map
    * import with empty schema -> create struct
    * load streams without headers
    * load from string with \n's and split (could be tricky to handle \n within strings)
    * auto create struct on import (all values are strings)
* dumper
    * handle an "id" key
    * dump!
    * dump structs
    * dump maps
    * create lists of fields to export from schema (e.g.  @csv dump: [except: :id])
* records
    * allow structs to have additional data (via Map.update() but struct access won't work)
* EctoCSV schema - can csv behaviour be treated as an extension to schema?
    * use plain ecto schema macros and functions
    * add csv specific macros

# Transform
* transformer.cast!