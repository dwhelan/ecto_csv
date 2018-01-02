defmodule CSV.TransformMacroTest do
  use CSV.TransformOld

  use ExUnit.Case

  test "downcase", do: assert downcase("Alice") === "alice"
  test "upcase",   do: assert   upcase("Alice") === "ALICE"
end
