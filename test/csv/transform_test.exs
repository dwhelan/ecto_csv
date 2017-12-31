defmodule CSV.TransformMacroTest do
  use CSV.Transform

  use ExUnit.Case

  test "downcase", do: assert downcase("Alice") === "alice"
  test "upcase",   do: assert   upcase("Alice") === "ALICE"
end

defmodule CSV.TransformTest do
  use ExUnit.Case
  require CSV.Transform, as: Transform

#  test "add_column(schema, name) should add a column with no options"

end
