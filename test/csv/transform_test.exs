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
      assert Transform.transform("123", {CSV.TransformTest, :to_int}) === {:ok, 123}
    end

    test "as a String" do
      assert Transform.transform("123", {"CSV.TransformTest", :to_int}) === {:ok, 123}
    end

    test "as an Atom" do
      assert Transform.transform("123", {:"CSV.TransformTest", :to_int}) === {:ok, 123}
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
    test "as a String" do
      assert Transform.transform("123", {CSV.TransformTest, "to_int"}) === {:ok, 123}
    end

    test "as an Atom" do
      assert Transform.transform("123", {CSV.TransformTest, :to_int}) === {:ok, 123}
    end

    test "as a String that includes module name" do
      assert Transform.transform("123", "CSV.TransformTest.to_int") === {:ok, 123}
    end

    test "as an Atom that includes module name" do
      assert Transform.transform("123", :"CSV.TransformTest.to_int") === {:ok, 123}
    end

    test "as a lambda to a named function" do
      assert Transform.transform("123", &to_int/1) === {:ok, 123}
    end

    test "as a lambda to an anonymous function" do
      assert Transform.transform("123", &(String.to_integer(&1))) === {:ok, 123}
    end
  end

  describe "args" do
  end

  describe "error handing" do
    test "with undefined function" do
      assert Transform.transform("123", :undefined_function) === {:error, "function Kernel.undefined_function/1 is undefined or private"}
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

    defmodule ErrorWithoutMessage do
      defexception [:value]
  
      def message(_) do
        raise UndefinedFunctionError
      end
    end
  
    test "with error without message() function" do
      to_int = &(raise CSV.TransformTest.ErrorWithoutMessage, value: &1)
      assert Transform.transform("123", to_int) === {:error, "%CSV.TransformTest.ErrorWithoutMessage{value: \"123\"}"}
    end
  end

  describe "special argument handling" do
    test "should return value if transforms is empty" do
      assert Transform.transform("123", []) === {:ok, "123"}
    end

    test "should return value if transforms is nil" do
      assert Transform.transform("123", nil) === {:ok, "123"}
    end

    test "should return value if transforms is not specified" do
      assert Transform.transform("123") === {:ok, "123"}
    end

    test "should ignore extra options" do
      assert Transform.transform("123", &to_int/1, foo: "bar") === {:ok, 123}
    end
  end
end
