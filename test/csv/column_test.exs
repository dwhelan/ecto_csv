defmodule CSV.ColumnTest do
  use ExUnit.Case
  require CSV.Column, as: Column

  describe "input type" do
    test "Integer" do
      col  = {"Name", [type: Integer]}
      assert Column.input(col, "123") === {:ok, 123}
    end

    test "String" do
      col  = {"Name", [type: String]}
      assert Column.input(col, "123") === {:ok, "123"}
    end
  end

  describe "input" do
    test "with no transform should return a cell with the value" do
      col  = {"Name", []}
      assert Column.input(col, "foo") === {:ok, "foo"}
    end

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
