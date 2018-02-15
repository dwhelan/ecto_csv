defmodule EctoCSV.Loader.SeparatorTest do
  use ExUnit.Case
  
  defmodule Default do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
    end
  end

  test "separator will default to 'comma'" do
    assert %{a: "1", b: "2"} = load(["a,b", "1,2"], Default)
  end

  defmodule Comma do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      separator ","
    end
  end

  test "that separator can be a comma" do
    assert %{a: "1", b: "2"} = load(["a,b", "1,2"], Comma)
  end

  defmodule Pipe do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      separator "|"
    end
  end

  test "separator can be a pipe" do
    assert %{a: "1", b: "2"} = load(["a|b", "1|2"], Pipe)
  end

  defmodule Tab do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      separator "\t"
    end
  end

  test "separator can be a tab" do
    assert %{a: "1", b: "2"} = load(["a\tb", "1\t2"], Tab)
  end

  defp load(stream, schema) do
    stream |> EctoCSV.Loader.load(schema) |> Enum.take(1) |> List.first
  end
end
