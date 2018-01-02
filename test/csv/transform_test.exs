defmodule CSV.ColumnTest do
  use ExUnit.Case
  require CSV.Transform, as: Transform

  def to_int(string) do
    String.to_integer(string)
  end

  describe "transform function" do
    test "as a String with module" do
      to_int = {CSV.ColumnTest, "to_int"}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as an Atom with module" do
      to_int = {CSV.ColumnTest, :to_int}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as a String that includes module name" do
      to_int = "CSV.ColumnTest.to_int"
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as an Atom that includes module name" do
      to_int = :"CSV.ColumnTest.to_int"
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as a lambda to a named function" do
      to_int = &to_int/1
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as a lambda to an anonymous function" do
      to_int = &(String.to_integer(&1))
      assert Transform.transform("123", to_int) === {:ok, 123}
    end
  end

  describe "transform module" do
    test "as a Module" do
      to_int = {CSV.ColumnTest, :to_int}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as a String" do
      to_int = {"CSV.ColumnTest", :to_int}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as an Atom" do
      to_int = {:"CSV.ColumnTest", :to_int}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as the first module in options[:modules]" do
      assert Transform.transform("123", :to_int, modules: [CSV.ColumnTest, String]) === {:ok, 123}
    end

    test "as the last module in options[:modules]" do
      assert Transform.transform("123", :to_int, modules: [String, CSV.ColumnTest]) === {:ok, 123}
    end

    test "as the only module in options[:modules]" do
      assert Transform.transform("123", :to_int, modules: [CSV.ColumnTest]) === {:ok, 123}
    end

    test "as the options[:modules]" do
      assert Transform.transform("123", :to_int, modules: CSV.ColumnTest) === {:ok, 123}
    end
  end

  test "should ignore extra options" do
    assert Transform.transform("123", &to_int/1, foo: "bar") === {:ok, 123}
  end
end
