defmodule EctoCSV.Dumper.ExtraColumnsTest do
  use ExUnit.Case

  defmodule Retain do
    use EctoCSV.Schema
    schema "test" do
      field :a
      field :z
    end

    csv do
      extra_columns :retain
    end 
  end

  test "should write extra columns after schema headers if extra_columns is ':retain'" do
    retain = Map.put(%Retain{a: "1", z: "2"}, :c, "3")
    assert ["a,z,c\r\n", "1,2,3\r\n"] = dump retain
  end

  defmodule Ignore do
    use EctoCSV.Schema
    schema "test" do
      field :a
      field :z
    end

    csv do
      extra_columns :ignore
    end 
  end

  test "should ignore extra columns if extra_columns is ':ignore'" do
    ignore = Map.put(%Ignore{a: "1", z: "2"}, :c, "3")
    assert ["a,z\r\n", "1,2\r\n"] = dump ignore
  end

  defmodule Error do
    use EctoCSV.Schema
    schema "test" do
      field :a
      field :z
    end

    csv do
      extra_columns :error
    end 
  end

  test "should ignore extra columns if extra_columns is ':error'" do
    error = Map.put(%Ignore{a: "1", z: "2"}, :c, "3")
    assert ["a,z\r\n", "1,2\r\n"] = dump error
  end

  defp dump(lines) do
    lines |> List.wrap |> EctoCSV.Dumper.dump |> Enum.to_list
  end
end
