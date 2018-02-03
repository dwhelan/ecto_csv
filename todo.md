# EctoCSV things to do
* handle header row with blank cells (allow code to specify name or field number)

* loader
    * file with headers - validate they match schema? use to map, missing, extra
    * get line numbers for error messages
    * handle an "id" key
    * load!
    * import with no schema -> create map
    * import with empty schema -> create struct
    * load streams without headers
    * load from string with \n's and split (could be tricky to handle \n within strings)

* dumper
    * handle an "id" key
    * dump!
    * dump structs
    * dump maps
    * create lists of fields to export from schema (e.g.  @csv dump: [except: :id])

* mix
    * `mix csv.create_schema <file> <schema path>` auto generate schema fields from header in file
