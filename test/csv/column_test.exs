defmodule CSV.ColumnTest do
  use ExUnit.Case
  require CSV.Column, as: Column

  def integer(string) do
    String.to_integer(string)
  end

  describe "transform function" do
    test "as a String with module" do
      transform = {CSV.ColumnTest, "integer"}
      assert Column.transform("123", transform) === {:ok, 123}
    end

    test "as an Atom with module" do
      transform = {CSV.ColumnTest, :integer}
      assert Column.transform("123", transform) === {:ok, 123}
    end

    test "as a String that includes module name" do
      transform = "CSV.ColumnTest.integer"
      assert Column.transform("123", transform) === {:ok, 123}
    end

    test "as an Atom that includes module name" do
      transform = :"CSV.ColumnTest.integer"
      assert Column.transform("123", transform) === {:ok, 123}
    end

    test "as a lambda to a named function" do
      transform = &integer/1
      assert Column.transform("123", transform) === {:ok, 123}
    end

    test "as a lambda to an anonymous function" do
      transform = &String.to_integer(&1)
      assert Column.transform("123", transform) === {:ok, 123}
    end
  end

  describe "transform module" do
    test "as a Module" do
      transform = {CSV.ColumnTest, :integer}
      assert Column.transform("123", transform) === {:ok, 123}
    end

    test "as a String" do
      transform = {"CSV.ColumnTest", :integer}
      assert Column.transform("123", transform) === {:ok, 123}
    end

    test "as an Atom" do
      transform = {:"CSV.ColumnTest", :integer}
      assert Column.transform("123", transform) === {:ok, 123}
    end

    test "as the first module in options[:modules]" do
      transform = :integer
      assert Column.transform("123", transform, modules: [CSV.ColumnTest, String]) === {:ok, 123}
    end

    test "as the last module in options[:modules]" do
      transform = :integer
      assert Column.transform("123", transform, modules: [String, CSV.ColumnTest]) === {:ok, 123}
    end

    test "as the only module in options[:modules]" do
      transform = :integer
      assert Column.transform("123", transform, modules: [CSV.ColumnTest]) === {:ok, 123}
    end

    test "as the options[:modules]" do
      transform = :integer
      assert Column.transform("123", transform, modules: CSV.ColumnTest) === {:ok, 123}
    end
  end

  test "should ignore extra options" do
    transform = &integer/1
    assert Column.transform("123", transform, foo: "bar") === {:ok, 123}
  end
end
