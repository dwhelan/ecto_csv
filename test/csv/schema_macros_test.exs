defmodule CSV.SchemaMacrosTest do
  use CSV.Schema

  column "Name"
  column "Age", type: Integer
  column "DOB", type: Date, format: "{YYYY}-{0M}-{0D}"

  use ExUnit.Case

  test "create columns" do
    assert schema().columns() === [
      {"Name", []},
      {"Age",  type: Integer},
      {"DOB",  type: Date, format: "{YYYY}-{0M}-{0D}"},
    ]
  end
end
