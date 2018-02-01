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

  defmodule HeadersTrue do
    use EctoCSV.Schema

    schema "test" do
      field :a
    end

    csv do
      header true
    end
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

  describe "that header" do
    test "will default to 'true'" do
      assert %{a: "1"} = hd(EctoCSV.Loader.load(["a", "1"], Default) |> Enum.take(1))
    end

    test "in stream will be used when header is 'true'" do
      assert %{a: "1"} = hd(EctoCSV.Loader.load(["a", "1"], HeadersTrue) |> Enum.take(1))
    end

    test "in schema will be used when header is 'false'" do
      assert %{a: "1"} = hd(EctoCSV.Loader.load(["1"], HeadersFalse) |> Enum.take(1))
    end
  end
end
