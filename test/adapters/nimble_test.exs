defmodule EctoCSV.Adapters.NimbleTest do
  require EctoCSV.Adapters.Nimble, as: CSV

  use ExUnit.Case

  describe "that read" do
    test "should support a comma separator" do
      lines = CSV.read(["a,b", "1,2"], separator: ",") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should support tab separator" do
      lines = CSV.read(["a\tb", "1\t2"], separator: "\t") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should support '|' separator" do
      lines = CSV.read(["a|b", "1|2"], separator: "|") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end
  end

  describe "that write" do
    @tag :skip
    test "should support a comma separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: ",") |> Enum.to_list
      assert lines == ["a,b", "1,2"]
    end
  end
end
