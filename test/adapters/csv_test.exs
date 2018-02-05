defmodule EctoCSV.Adapters.CSVTest do
  alias EctoCSV.Adapters.CSV

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

  describe "that decode" do
    test "should decode with comma as the separator" do
      lines = CSV.decode(["a,b", "1,2"], Default) |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should decode with '|' as the separator" do
      lines = CSV.decode(["a|b", "1|2"], Pipe) |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end
  end
end
