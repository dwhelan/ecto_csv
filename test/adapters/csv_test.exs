defmodule EctoCSV.Adapters.CSVTest do
  alias EctoCSV.Adapters.CSV

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
    test "should support a comma separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: ",") |> Enum.to_list
      assert lines == ["a,b\r\n", "1,2\r\n"]
    end

    test "should support a tab separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: "\t") |> Enum.to_list
      assert lines == ["a\tb\r\n", "1\t2\r\n"]
    end

    test "should support a '|' separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: "|") |> Enum.to_list
      assert lines == ["a|b\r\n", "1\|2\r\n"]
    end
  end
end
