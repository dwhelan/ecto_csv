defmodule EctoCSV.Dumper.DelimiterTest do
  use ExUnit.Case

  defmodule Default do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b, :integer
      field :c, :float
    end

    csv do
    end
  end

  test "by default that lines are written with a delimiter of '\r\n'" do
    assert ["a,b,c\r\n", "a,1,2.3\r\n"] = dump(%Default{a: "a", b: 1, c: 2.3})
  end

  defmodule LF do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b, :integer
      field :c, :float
    end

    csv do
      delimiter "\n"
    end
  end

  test "that lines can be written with a delimiter of '\n'" do
    assert ["a,b,c\n", "a,1,2.3\n"] = dump(%LF{a: "a", b: 1, c: 2.3})
  end

  defmodule CRLF do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b, :integer
      field :c, :float
    end

    csv do
      delimiter "\r\n"
    end
  end

  test "that lines can be written with a delimiter of '\r\n'" do
    assert ["a,b,c\r\n", "a,1,2.3\r\n"] = dump(%CRLF{a: "a", b: 1, c: 2.3})
  end

  defp dump(lines) do
    EctoCSV.Dumper.dump(List.wrap(lines)) |> Enum.to_list
  end
end
