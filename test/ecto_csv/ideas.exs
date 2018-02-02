defmodule EctoCSV.Ideas do
  use ExUnit.Case

  defmodule Source do
    use EctoCSV.Schema

    schema "source" do end

    csv do
      # Default setting (header: true)
      # Loading:
      #   Order of fields in header is used to map row data.
      #   As stringent as possible rules be applied to processing the header
      #   Header values are compared against schema fields.
      #   Checking will allow the listed exceptions (none)
      #   You can provide a single value or a list.
      # Dumping:
      #   Data is written in order of .
      header true, allow: [:missing_columns, :whitespace_differences, :case_differences, :all, :none]
      
      # Loading:
      #   Order of fields in schema is used to map row data.
      #   Use when supplier can't provide headers.
      # Dumping:
      #   Header is not written.
      header false
      
      # Loading:
      #   Header is read and discarded.
      #   Schema columns are used to describe rows.
      # Dumping:
      #   Header is written as defined by schema.
      header :ignore

      # 
      # Loading:
      #   The first row is checked to see if it matches the schema.
      #   If it does then the row is assumed to be a header
      #   If it does not then the row is assumed to be a data row.
      # Dumping:
      #   
      header :optional                          # same as `header optional: true`
      header optional: true                     # apply header if all rules when checking header existence are met
      header optional: :ignore                  # ignore if present & apply all rules when checking header existence
      header optional: allow: [:extra_columns]  # treat as a header even with extra columns

      # Extra columns have headers that exist in a file but not in the schema
      extra_columns :retain     # data in extra columns will be retained with field name from file header (default)
      extra_columns :ignore     # data in extra columns will be discarded on load
      extra_columns :error      # file will generate an error when loaded if it has extra headers
      extra_columns rename: ""  # extra headers will be loaded & set to "" on dump - all row data will be preserved
    end
  end
end
