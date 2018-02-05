defmodule EctoCSV.Dumper.ExtraColumnsTest do
  use ExUnit.Case

  defmodule Default do
    use EctoCSV.Schema
    schema "test" do
      field :a
      field :b
    end

    csv do end 
  end

  test "should dump extra columns by default" do
    default = %Default{a: "1", b: "2"}
    assert ["a,b\r\n", "1,2\r\n"] = dump default
  end

  defp dump(lines) do
    EctoCSV.Dumper.dump(List.wrap(lines)) |> Enum.to_list
  end
end
