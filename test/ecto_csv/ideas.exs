defmodule EctoCSV.Ideas do
  use ExUnit.Case


  defmodule Source do
    use EctoCSV.Schema

    schema "source" do end

    csv do
      # Data is read and uses order of fields in schema to map supplier data.
      # Use when supplier can't provide headers
      header false
      
      # Header is expected from the supplier and it is read and discarded
      header :ignore

      # Supplier headers are compared against schema fields
      # Validations will allow the listed rules.
      # You can list a single value or a list.
      header allow: [
        :extra,
        :missing,
        :whitespace,
        :case,
        :all,
        :none
      ]

      # Applies all validations
      header :validate      

      # The first row is checked to see if it matches the schema.
      # If it does then the value is applied to the header,
      header optional: :ignore    # ignore if present
      header optional: :validate: # apply all validations

      # Equivalent to `header optional: :validate`
      header :optional

      # No specification of header defaults to `header :validate`
    end
  end
end
