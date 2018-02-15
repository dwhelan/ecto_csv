defmodule EctoCSV.Dumper.HeaderTest do
  use ExUnit.Case
  
  defmodule Default do
    use EctoCSV.Schema

    schema "test" do
      field :b
      field :a
    end

    csv do end
  end

  test "values are dumped in schema order by default" do
    assert ["b,a\r\n", "2,1\r\n"] = dump(%Default{a: 1, b: 2})
  end

  defmodule HeadersTrue do
    use EctoCSV.Schema

    schema "test" do
      field :b
      field :a
    end

    csv do
      header true
    end
  end

  test "values are dumped in schema order when headers is 'true'" do
    assert ["b,a\r\n", "2,1\r\n"] = dump(%HeadersTrue{a: 1, b: 2})
  end

  defmodule HeadersFalse do
    use EctoCSV.Schema

    schema "test" do
      field :b
      field :a
    end

    csv do
      header false
    end
  end

  test "headers are not written when headers is 'false'" do
    assert ["2,1\r\n"] = dump(%HeadersFalse{a: 1, b: 2})
  end

  defp dump(lines) do
    lines |> List.wrap |> EctoCSV.Dumper.dump |> Enum.to_list
  end
end
