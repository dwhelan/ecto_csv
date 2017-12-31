defmodule CSV.ColumnTest do
  use ExUnit.Case
  require CSV.Column, as: Column

  describe "input" do
    test "with no transforms should return a cell with the value" do
      col  = {"Name", []}
      assert Column.input(col, "foo") === {:ok, ["foo"]}
    end

    test "with a transfor should return a cell with the transformed value" do
      col  = {"Name", [transform: &String.upcase/1]}
      assert Column.input(col, "foo") === {:ok, ["FOO", "foo"]}
    end
  end
end
