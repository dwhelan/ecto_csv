defmodule EctoCSV.Loader.SeparatorTest do
  use ExUnit.Case
  
  defmodule Example do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
    end
  end

  defmodule ExampleWithComma do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      separator ","
    end
  end

  defmodule ExampleWithVerticalBar do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      separator "|"
    end
  end

  describe "that separator" do
    test "will default to 'comma'" do
      assert %{a: "1", b: "2"} = hd(EctoCSV.Loader.load(["a,b", "1,2"], Example) |> Enum.take(1))
    end

    test "will allow a comma" do
      assert %{a: "1", b: "2"} = hd(EctoCSV.Loader.load(["a,b", "1,2"], ExampleWithComma) |> Enum.take(1))
    end

    test "will allow an arbitrary character" do
      assert %{a: "1", b: "2"} = hd(EctoCSV.Loader.load(["a|b", "1|2"], ExampleWithVerticalBar) |> Enum.take(1))
    end
  end
end
