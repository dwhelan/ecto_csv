defmodule EctoCSV.Dumper.ExtraColumnsTest do
  use ExUnit.Case

  defmodule Retain do
    use EctoCSV.Schema
    schema "test" do
      field :a
      field :b
    end

    csv do
      extra_columns :retain
    end 
  end

  test "should write extra columns if extra_columns is ':retain'" do
    default = Map.put(%Retain{a: "1", b: "2"}, :c, "3")
    assert ["a,b,c\r\n", "1,2,3\r\n"] = dump default
  end

  defp dump(lines) do
    EctoCSV.Dumper.dump(List.wrap(lines)) |> Enum.to_list
  end
end
