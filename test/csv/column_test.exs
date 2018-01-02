defmodule CSV.ColumnTest do
  use ExUnit.Case
  require CSV.Column, as: Column

  def integer(string) do
    String.to_integer(string)
  end

  describe "transform function" do
    test "as a String" do
      col = {CSV.ColumnTest, "integer"}
      assert Column.transform(col, "123") === {:ok, 123}
    end

    test "as an Atom" do
      col = {CSV.ColumnTest, :integer}
      assert Column.transform(col, "123") === {:ok, 123}
    end

    test "as a String that includes module name" do
      col = "CSV.ColumnTest.integer"
      assert Column.transform(col, "123") === {:ok, 123}
    end

    test "as an Atom that includes module name" do
      col = :"CSV.ColumnTest.integer"
      assert Column.transform(col, "123") === {:ok, 123}
    end

    test "as a lambda to a named function" do
      col = &integer/1
      assert Column.transform(col, "123") === {:ok, 123}
    end

    test "as a lambda to an anonymous function" do
      col = &String.to_integer(&1)
      assert Column.transform(col, "123") === {:ok, 123}
    end
  end

  describe "transform module" do
    test "as a Module" do
      col = {CSV.ColumnTest, :integer}
      assert Column.transform(col, "123") === {:ok, 123}
    end

    test "as a String" do
      col = {"CSV.ColumnTest", :integer}
      assert Column.transform(col, "123") === {:ok, 123}
    end

    test "as an Atom" do
      col = {:"CSV.ColumnTest", :integer}
      assert Column.transform(col, "123") === {:ok, 123}
    end

    test "as the first module in options[:modules]" do
      col = :integer
      assert Column.transform(col, "123", modules: [CSV.ColumnTest, String]) === {:ok, 123}
    end

    test "as the last module in options[:modules]" do
      col = :integer
      assert Column.transform(col, "123", modules: [String, CSV.ColumnTest]) === {:ok, 123}
    end

    test "as the only module in options[:modules]" do
      col = :integer
      assert Column.transform(col, "123", modules: [CSV.ColumnTest]) === {:ok, 123}
    end

    test "as the options[:modules]" do
      col = :integer
      assert Column.transform(col, "123", modules: CSV.ColumnTest) === {:ok, 123}
    end
  end

  test "should ignore extra options" do
    col = &integer/1
    assert Column.transform(col, "123", foo: "bar") === {:ok, 123}
  end
end
