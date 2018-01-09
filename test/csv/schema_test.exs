defmodule CSV.SchemaTest do
  use ExUnit.Case
  require CSV.Schema, as: Schema

  test "add_column(schema, name) should add a column with no options" do
    schema = Schema.add_column(%{}, "Name")
    assert schema.columns ===     [{"Name", String, []}]
  end

  test "add_column(schema, name, options) should add a column with options" do
    schema = Schema.add_column(%{}, "DOB", Date, format: "{YYYY}-{0M}-{0D}")
    assert schema.columns ===     [{"DOB", Date, format: "{YYYY}-{0M}-{0D}"}]
  end
end
