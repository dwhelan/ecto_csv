defmodule EctoCSV.Adapters.NimbleTest do
  require EctoCSV.Adapters.Nimble, as: CSV

  use ExUnit.Case

  describe "that read" do
    test "should read with comma as the separator" do
      lines = CSV.read(["a,b", "1,2"], separator: ",") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should read with '|' as the separator" do
      lines = CSV.read(["a|b", "1|2"], separator: "|") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end
  end
end
