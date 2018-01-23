defmodule EctoCSV.Loader.DelimiterTest do
  require Briefly
  use ExUnit.Case
  
  defmodule Example do
    use EctoCSV.Schema

    schema "test" do
      field :a
    end

    csv do
    end
  end

  defmodule ExampleWithComma do
    use EctoCSV.Schema

    schema "test" do
      field :a
    end

    csv do
      # delimiter ","
    end
  end

  defmodule ExampleWithVerticalBar do
    use EctoCSV.Schema

    schema "test" do
      field :a
    end

    csv do
      # delimiter "|"
    end
  end

  describe "that delimiter" do
    test "will default to 'comma'" do
      assert %{a: "1"} = hd(EctoCSV.Loader.load(["a", "1"], Example) |> Enum.take(1))
    end

    @tag :wip
    test "will use specified delimiter" do
      assert %{a: "1"} = hd(EctoCSV.Loader.load(["a", "1"], ExampleWithComma) |> Enum.take(1))
    end

    @tag :wip
    test "in schema will be used when header is 'false'" do
      assert %{a: "1"} = hd(EctoCSV.Loader.load(["1"], ExampleWithVerticalBar) |> Enum.take(1))
    end
  end
end
