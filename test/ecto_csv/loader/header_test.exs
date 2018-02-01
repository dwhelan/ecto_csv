defmodule EctoCSV.Loader.HeaderTest do
  use ExUnit.Case
  
  defmodule Default do
    use EctoCSV.Schema

    schema "test" do
      field :a
    end

    csv do
    end
  end

  test "header will default to 'true'" do
    assert %{a: "1"} = load(["a", "1"], Default)
  end

  defmodule HeadersTrue do
    use EctoCSV.Schema

    schema "test" do
      field :a
    end

    csv do
      header true
    end
  end

  test "header will be loaded when header is 'true'" do
    assert %{a: "1"} = load(["a", "1"], HeadersTrue)
  end

  defmodule HeadersFalse do
    use EctoCSV.Schema

    schema "test" do
      field :a
    end

    csv do
      header false
    end
  end

  test "header will be from schema when header is 'false'" do
    assert %{a: "1"} = load(["1"], HeadersFalse)
  end

  defp load(path, schema) do
    hd(EctoCSV.Loader.load(path, schema) |> Enum.take(1))
  end
end
