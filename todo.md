# EctoCSV things to do
* handle header row with blank cells (allow code to specify name or field number)

* loader
    * get line numbers for error messages
    * allow missing columns: missing_columns :ignore, :error, [list of columns allowed to be missing]
    * handle an "id" key
    * load!
    * import with no schema -> create map
    * load from string with \n's and split (could be tricky to handle \n within strings)

* dumper
    * handle an "id" key
    * dump!
    * dump structs
    * dump maps
    * create lists of fields to export from schema (e.g.  @csv dump: [except: :id])

* mix
    * `mix csv.create_schema <file> <schema path>` auto generate schema fields from header in file
