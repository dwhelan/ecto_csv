# CSV
* rename to EctoCSV
* loader
    * import with no schema
    * load streams without headers
    * load from string with \n's and split (could be tricky to handle \n within strings)
    * auto create struct on import (all values are strings)

* dumper
    * get headers at compile time from schema
    * dump structs without schemas
    * dump maps
    * dump lists
* headers
    * file with no headers - assume ordinality of configured columns
    * file with headers
* records
    * allow structs to have additional data (via Map.update() but struct access won't work)
* CSV schema - can csv behaviour be treated as an extension to schema?
    * use plain ecto schema macros and functions
    * add csv specific macros