defmodule CSV.ColumnTest do
  use ExUnit.Case
  require CSV.Column, as: Column

  def integer(string) do
    String.to_integer(string)
  end

  describe "transform function" do
    test "as a String" do
      col = {"Name", {CSV.ColumnTest, "integer"} }
      assert Column.input2(col, "123") === {:ok, 123}
    end

    test "as an Atom" do
      col = {"Name", {CSV.ColumnTest, :integer} }
      assert Column.input2(col, "123") === {:ok, 123}
    end

    test "as a String that includes module name" do
      col = {"Name", "CSV.ColumnTest.integer" }
      assert Column.input2(col, "123") === {:ok, 123}
    end

    test "as an Atom that includes module name" do
      col = {"Name", :"CSV.ColumnTest.integer" }
      assert Column.input2(col, "123") === {:ok, 123}
    end

    test "as a lambda to a named function" do
      col = {"Name", &integer/1}
      assert Column.input2(col, "123") === {:ok, 123}
    end

    test "as a lambda to an anonymous function" do
      col = {"Name", &String.to_integer(&1)}
      assert Column.input2(col, "123") === {:ok, 123}
    end
  end

  describe "transform modules" do
    test "as a Module" do
      col = {"Name", {CSV.ColumnTest, :integer} }
      assert Column.input2(col, "123") === {:ok, 123}
    end

    test "as a String" do
      col = {"Name", {"CSV.ColumnTest", :integer} }
      assert Column.input2(col, "123") === {:ok, 123}
    end

    test "as an Atom" do
      col = {"Name", {:"CSV.ColumnTest", :integer} }
      assert Column.input2(col, "123") === {:ok, 123}
    end

    test "as the first module in options[:modules]" do
      col = {"Name", :integer }
      assert Column.input2(col, "123", modules: [CSV.ColumnTest, String]) === {:ok, 123}
    end

    test "as the last module in options[:modules]" do
      col = {"Name", :integer }
      assert Column.input2(col, "123", modules: [String, CSV.ColumnTest]) === {:ok, 123}
    end

    test "as the only module in options[:modules]" do
      col = {"Name", :integer }
      assert Column.input2(col, "123", modules: [CSV.ColumnTest]) === {:ok, 123}
    end

    test "as the options[:modules]" do
      col = {"Name", :integer }
      assert Column.input2(col, "123", modules: CSV.ColumnTest) === {:ok, 123}
    end
  end

  describe "input type" do
    test "Integer" do
      col = {"Name", [type: Integer]}
      assert Column.input(col, "123") === {:ok, 123}
    end

    test "Integer atom" do
      col = {"Name", [type: :Integer]}
      assert Column.input(col, "123") === {:ok, 123}
    end

    test "Integer string" do
      col = {"Name", [type: "Integer"]}
      assert Column.input(col, "123") === {:ok, 123}
    end

    test "bad Integer" do
      col = {"Name", [type: Integer]}
      assert Column.input(col, "abc") === {:error, ["'abc' is not an Integer"]}
    end

    test "String" do
      col = {"Name", [type: String]}
      assert Column.input(col, "123") === {:ok, "123"}
    end

    test "String string" do
      col = {"Name", [type: "String"]}
      assert Column.input(col, "123") === {:ok, "123"}
    end

    test "invalid type" do
      col = {"Name", [type: "Bad Type"]}
      assert Column.input(col, "123") === {:error, ["unknown type 'Bad Type'"]}
    end

    test "should use first type with multiple types" do
      col = {"Name", [type: String, type: Integer]}
      assert Column.input(col, "123") === {:ok, "123"}
    end
  end

  describe "input transform" do
    test "with no transform should return a cell with the value" do
      col = {"Name", []}
      assert Column.input(col, "foo") === {:ok, "foo"}
    end

    test "should return transformed value" do
      col = {"Name", [transform: &String.upcase/1]}
      assert Column.input(col, "foo") === {:ok, "FOO"}
    end

    test "should allow String functions to be specified with an Atom" do
      col = {"Name", [transform: :upcase]}
      assert Column.input(col, "foo") === {:ok, "FOO"}
    end

    test "should allow String functions to be specified with an String" do
      col = {"Name", [transform: "upcase"]}
      assert Column.input(col, "foo") === {:ok, "FOO"}
    end

    test "should multiple transforms" do
      col = {"Name", [transform: "upcase", transform: "capitalize"]}
      assert Column.input(col, "foo") === {:ok, "Foo"}
    end

    test "with an invalid function should return the error message" do
      col = {"Name", [transform: &Foo.bar/1]}
      assert Column.input(col, "foo") === {:error, ["function Foo.bar/1 is undefined (module Foo is not available)"]}
    end

    test "with a pattern matching error should return the error message" do
      col = {"Name", [transform: &Integer.digits/1]}
      assert Column.input(col, "foo") === {:error, ["no function clause matching in Integer.digits/2"]}
    end
  end

  test "should ignore extra options" do
    col = {"Name", [transform: &String.upcase/1, foo: "bar"]}
    assert Column.input(col, "foo") === {:ok, "FOO"}
  end
end

