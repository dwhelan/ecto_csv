defmodule EctoCSV.Loader.ExtraColumnsWithoutHeadersTest do
  alias EctoCSV.LoadError
  use ExUnit.Case
  
  defmodule Retain do
    use EctoCSV.Schema
    schema "" do field :a end
    csv do
      header false
      extra_columns :retain
    end
  end

  test "with :retain extra values should be loaded as field 'Fieldn'" do
    assert %{a: "1", Field2: "2", Field3: "3"} = load ["1,2,3"], Retain
  end

  defmodule Ignore do
    use EctoCSV.Schema
    schema "" do field :a end
    csv do
      header false
      extra_columns :ignore
    end
  end

  test "with :ignore extra values should be ignored" do
    loaded = load ["1,2,3"], Ignore
    assert %{a: "1"} = loaded
    refute Map.has_key?(loaded, :Field1)
  end

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
