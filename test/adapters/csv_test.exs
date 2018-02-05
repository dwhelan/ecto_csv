defmodule EctoCSV.Adapters.CSVTest do
  alias EctoCSV.Adapters.CSV

  use ExUnit.Case

  describe "that read" do
    test "should decode with comma as the separator" do
      lines = CSV.read(["a,b", "1,2"], separator: ",") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should write with '|' as the separator" do
      lines = CSV.read(["a|b", "1|2"], separator: "|") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end
  end
end
