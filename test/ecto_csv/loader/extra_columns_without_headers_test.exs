defmodule EctoCSV.Loader.ExtraColumnsWithoutHeadersTest do
  alias EctoCSV.LoadError
  use ExUnit.Case
  
  defmodule Retain do
    use EctoCSV.Schema
    schema "test" do field :a end
    csv do
      header false
      extra_columns :retain
    end
  end

  test "with :retain an extra value should be loaded as field 'Fieldn'" do
    assert %{a: "1", Field2: "2"} = load ["1,2"], Retain
  end

  test "with :retain  multiple extra values should be loaded as field 'Fieldn'" do
    assert %{a: "1", Field2: "2", Field3: "3"} = load ["1,2,3"], Retain
  end

  # test "more fields than column headers should raise an error" do
  #   assert_raise LoadError, "extra fields found on line 2", fn ->
  #     load ["x", "1,2"], Default
  #   end 
  #  end

  # defmodule Ignore do
  #   use EctoCSV.Schema
  #   schema "test" do end
  #   csv do extra_columns :ignore end
  # end

  # test "headers not defined in the schema should be ignored if extra_columns set to :ignore" do
  #   struct = load ["x", "1"], Ignore
  #   refute Map.has_key? struct, :x
  # end

  # defmodule Error do
  #   use EctoCSV.Schema
  #   schema "test" do end
  #   csv do extra_columns :error end
  # end

  # test "headers not defined in the schema should raise an error if extra_columns set to :error" do
  #   assert_raise LoadError, "extra column 'x' found on line 1", fn ->
  #      load ["x", "1"], Error
  #   end 
  # end

  defp load(lines, schema) do
    EctoCSV.Loader.load(lines, schema) |> Enum.take(1) |> List.first
  end
end
