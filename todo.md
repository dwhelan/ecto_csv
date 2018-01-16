# CSV
* handle header row with blank cells (allow code to specify name or field number)
* rename to EctoCSV
* loader
    * import with no schema -> create map
    * import with empty schema -> create struct
    * load streams without headers
    * load from string with \n's and split (could be tricky to handle \n within strings)
    * auto create struct on import (all values are strings)
* dumper
    * get headers at compile time from schema
    * optional headers
    * dump structs
    * dump maps
* headers
    * file with no headers - assume ordinality of configured fields
    * file with headers
* records
    * allow structs to have additional data (via Map.update() but struct access won't work)
* CSV schema - can csv behaviour be treated as an extension to schema?
    * use plain ecto schema macros and functions
    * add csv specific macros

# Transform
* transformer.cast!