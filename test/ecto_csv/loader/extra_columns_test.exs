defmodule EctoCSV.Loader.ExtraColumnsTest do
  alias EctoCSV.LoadError
  use ExUnit.Case

  defmodule EmptyDefault do
    use EctoCSV.Schema
    schema "test" do end
    csv do end
  end

  describe "that by default with an empty schema" do
    test "headers not defined in the schema have values loaded as strings" do
      assert %{x: "1"} = load ["x", "1"], EmptyDefault
    end
    
    test "more fields than headers should dynamicaly create a new header" do
      assert %{x: "1", Field2: "2"} = load ["x", "1,2"], EmptyDefault
    end
  end

  defmodule Default do
    use EctoCSV.Schema
    schema "test" do field :a end
    csv do end
  end

  describe "that by default with a non-empty schema" do
    test "missing headers raises an error" do
      assert_raise LoadError, "missing headers 'a' on line 1", fn ->
        load ["x", "1"], Default
      end 
    end

    test "headers not defined in the schema have values loaded as strings" do
      assert %{a: "1", x: "2"} = load ["a,x", "1,2"], Default
    end

    test "more fields than headers should dynamicaly create a new header" do
      assert %{a: "1", x: "2", Field3: "3"} = load ["a,x", "1,2,3"], Default
    end
  end

  defmodule EmptyIgnore do
    use EctoCSV.Schema
    schema "test" do end
    csv do extra_columns :ignore end
  end

  describe "that with 'extra_columns :ignore' and an empty schema" do
    test "headers and fields not defined in the schema should be ignored" do
      struct = load ["x", "1"], EmptyIgnore
      refute Map.has_key? struct, :x
    end
  end

  defmodule Ignore do
    use EctoCSV.Schema
    schema "test" do field :a end
    csv do extra_columns :ignore end
  end

  describe "that with 'extra_columns :ignore' and a non-empty schema" do
    test "headers not defined in the schema should be ignored" do
      struct = load ["a,x", "1,2"], Ignore
      assert %{a: "1"} = struct
      refute Map.has_key? struct, :x
    end
  end

  defmodule EmptyError do
    use EctoCSV.Schema
    schema "test" do end
    csv do extra_columns :error end
  end

  describe "that with 'extra_columns :error' and an empty schema" do
    test "headers not defined in the schema should raise an error" do
      assert_raise LoadError, "extra headers 'x' found on line 1", fn ->
        load ["x", "1"], EmptyError
      end 
    end
  end

  defmodule Error do
    use EctoCSV.Schema
    schema "test" do field :a end
    csv do extra_columns :error end
  end

  describe "that with 'extra_columns :error' and a non-empty schema" do
    test "headers not defined in the schema should raise an error" do
      assert_raise LoadError, "extra headers 'x' found on line 1", fn ->
        load ["a,x", "1,2"], Error
      end 
    end
  end

  defp load(lines, schema) do
    EctoCSV.Loader.load(lines, schema) |> Enum.take(1) |> List.first
  end
end
