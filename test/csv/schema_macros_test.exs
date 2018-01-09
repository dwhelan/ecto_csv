defmodule CSV.SchemaMacrosTest do
  use CSV.Schema
  use ExUnit.Case

  column "Name"
  column "Age", Integer
  column "DOB", Date, format: "{YYYY}-{0M}-{0D}"

  test "column with a name only defaults module to 'String'" do
    assert @schema.columns["Name"] === {String, []}
  end

  test "column with a module sets the module" do
    assert @schema.columns["Age"] === {Integer, []}
  end

  test "column with module and options sets both" do
    assert @schema.columns["DOB"] === {Date, format: "{YYYY}-{0M}-{0D}"}
  end
end
