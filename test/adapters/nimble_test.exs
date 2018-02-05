defmodule EctoCSV.Adapters.NimbleTest do
  require EctoCSV.Adapters.Nimble, as: CSV

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

  describe "that read" do
    test "should read with comma as the separator" do
      lines = CSV.read(["a,b", "1,2"], Default) |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should read with '|' as the separator" do
      lines = CSV.read(["a|b", "1|2"], Pipe) |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end
  end
end
