defmodule CSV.TransformTest do
  use ExUnit.Case
  require CSV.Transform, as: Transform

  def to_int(string) do
    String.to_integer(string)
  end

  def int_to_string(value) when is_integer(value) do
    Integer.to_string(value)
  end

  describe "module" do
    test "as a Module" do
      to_int = {CSV.TransformTest, :to_int}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as a String" do
      to_int = {"CSV.TransformTest", :to_int}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as an Atom" do
      to_int = {:"CSV.TransformTest", :to_int}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as the first module in options[:module]" do
      assert Transform.transform("123", :to_int, module: [CSV.TransformTest, String]) === {:ok, 123}
    end

    test "as the last module in options[:module]" do
      assert Transform.transform("123", :to_int, module: [String, CSV.TransformTest]) === {:ok, 123}
    end

    test "as the only module in options[:module]" do
      assert Transform.transform("123", :to_int, module: [CSV.TransformTest]) === {:ok, 123}
    end

    test "as the options[:module]" do
      assert Transform.transform("123", :to_int, module: CSV.TransformTest) === {:ok, 123}
    end
  end

  describe "function" do
    test "as a String with module" do
      to_int = {CSV.TransformTest, "to_int"}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as an Atom with module" do
      to_int = {CSV.TransformTest, :to_int}
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as a String that includes module name" do
      to_int = "CSV.TransformTest.to_int"
      assert Transform.transform("123", to_int) === {:ok, 123}
    end

    test "as an Atom that includes module name" do
      to_int = :"CSV.TransformTest.to_int"
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

  describe "args" do
  end

  defmodule ErrorWithoutMessage do
    defexception [:value]

    def message(_) do
      raise UndefinedFunctionError
    end
  end

  describe "error handing" do
    test "with undefined function" do
      assert Transform.transform("123", :undefined_function) === {:error, "function Elixir.undefined_function/1 is undefined (module Elixir is not available)"}
    end

    test "with function clause error" do
      assert Transform.transform("123", :int_to_string, module: CSV.TransformTest) === {:error, "no function clause matching in CSV.TransformTest.int_to_string/1"}
    end

    test "with error raised by function" do
      to_int = &(raise "error in to_int(#{&1})")
      assert Transform.transform("123", to_int) === {:error, "error in to_int(123)"}
    end

    test "with error thrown by function" do
      to_int = &(throw "error in to_int(#{&1})")
      assert Transform.transform("123", to_int) === {:error, "error in to_int(123)"}
    end

    test "with error without message() function" do
      to_int = &(raise CSV.TransformTest.ErrorWithoutMessage, value: &1)
      assert Transform.transform("123", to_int) === {:error, "%CSV.TransformTest.ErrorWithoutMessage{value: \"123\"}"}
    end
  end

  test "should ignore extra options" do
    assert Transform.transform("123", &to_int/1, foo: "bar") === {:ok, 123}
  end
end
