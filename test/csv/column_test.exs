defmodule CSV.ColumnTest do
  use ExUnit.Case
  require CSV.Column, as: Column

  describe "input" do
    test "with no transform should return a cell with the value" do
      col  = {"Name", []}
      assert Column.input(col, "foo") === {:ok, "foo"}
    end

#    test "with a type should return a cell with the parsed value" do
#      col  = {"Name", [type: Integer]}
#      assert Column.input(col, "123") === {:ok, [123]}
#    end

    test "with a transform should return a cell with the transformed value" do
      col  = {"Name", [transform: &String.upcase/1]}
      assert Column.input(col, "foo") === {:ok, "FOO"}
    end

    test "should ignore extra options" do
      col  = {"Name", [transform: &String.upcase/1, foo: "bar"]}
      assert Column.input(col, "foo") === {:ok, "FOO"}
    end

  end
end
