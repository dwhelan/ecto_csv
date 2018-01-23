defmodule EctoCSV.Loader.HeaderTest do
  use ExUnit.Case
  
  defmodule Example do
    use EctoCSV.Schema

    schema "test" do
      field :a
    end

    csv do
    end
  end

  defmodule ExampleWithHeaders do
    use EctoCSV.Schema

    schema "test" do
      field :a
    end

    csv do
      header true
    end
  end

  defmodule ExampleWithoutHeaders do
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
      assert %{a: "1"} = hd(EctoCSV.Loader.load(["a", "1"], Example) |> Enum.take(1))
    end

    test "in stream will be used when header is 'true'" do
      assert %{a: "1"} = hd(EctoCSV.Loader.load(["a", "1"], ExampleWithHeaders) |> Enum.take(1))
    end

    test "in schema will be used when header is 'false'" do
      assert %{a: "1"} = hd(EctoCSV.Loader.load(["1"], ExampleWithoutHeaders) |> Enum.take(1))
    end
  end
end
