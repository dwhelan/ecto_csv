defmodule EctoCSV.Loader.ExtraColumnsTest do
  require Briefly
  use ExUnit.Case
  
  defmodule Example do
    use EctoCSV.Schema
    schema "test" do end
    csv do end
  end

  test "by default fields not defined in the schema are retained as strings" do
    assert %{x: "1"} = load(["x", "1"], Example)
  end

  defmodule Ignore do
    use EctoCSV.Schema
    schema "test" do end
    csv do extra_columns :ignore end
  end

  test "fields not defined in the schema should be ignored if extra_columns set to :ignore" do
    struct = load ["x", "1"], Ignore
    refute Map.has_key? struct, :x
  end

  defmodule Error do
    use EctoCSV.Schema
    schema "test" do end
    csv do extra_columns :error end
  end

  test "fields not defined in the schema should raise an error if extra_columns set to :error" do
    assert_raise ArgumentError, "extra column 'x' found", fn ->
       load ["x", "1"], Error
    end 
  end

  defp load(lines, schema) do
    EctoCSV.Loader.load(lines, schema) |> Enum.take(1) |> List.first
  end
end
