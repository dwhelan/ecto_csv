defmodule EctoCSV.Adapters.NimbleTest do
  require EctoCSV.Adapters.Nimble, as: CSV

  use ExUnit.Case

  describe "that read" do
    test "should support a comma separator" do
      lines = CSV.read(["a,b\r\n", "1,2\r\n"], separator: ",") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should support tab separator" do
      lines = CSV.read(["a\tb\r\n", "1\t2\r\n"], separator: "\t") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should support '|' separator" do
      lines = CSV.read(["a|b\r\n", "1|2\r\n"], separator: "|") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should default to a comma separator and a '\\r\\n' delimiter" do
      lines = CSV.read(["a,b\r\n", "1,2\r\n"]) |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should handle a '\\n' delimiter by default" do
      lines = CSV.read(["a,b\n", "1,2\n"]) |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end
  end

  describe "that write with a delimiter of '\\r\\n'" do
    test "should support a comma separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: ",", delimiter: "\r\n") |> Enum.to_list
      assert lines == ["a,b\r\n", "1,2\r\n"]
    end

    test "should support a tab separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: "\t", delimiter: "\r\n") |> Enum.to_list
      assert lines == ["a\tb\r\n", "1\t2\r\n"]
    end

    test "should support a '|' separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: "|", delimiter: "\r\n") |> Enum.to_list
      assert lines == ["a|b\r\n", "1\|2\r\n"]
    end
  end

  describe "that write with delimiter of '\\n'" do
    test "should support a comma separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: ",", delimiter: "\n") |> Enum.to_list
      assert lines == ["a,b\n", "1,2\n"]
    end

    test "should support a tab separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: "\t", delimiter: "\n") |> Enum.to_list
      assert lines == ["a\tb\n", "1\t2\n"]
    end

    test "should support a '|' separator" do
      lines = CSV.write([["a", "b"], ["1", "2"]], separator: "|", delimiter: "\n") |> Enum.to_list
      assert lines == ["a|b\n", "1\|2\n"]
    end
  end

  test "that write should default delimiter to '\\r\\n'" do
    lines = CSV.write([["a", "b"], ["1", "2"]], separator: ",") |> Enum.to_list
    assert lines == ["a,b\r\n", "1,2\r\n"]
  end


  test "that write should default separator to a comma" do
    lines = CSV.write([["a", "b"], ["1", "2"]], delimiter: "\r\n") |> Enum.to_list
    assert lines == ["a,b\r\n", "1,2\r\n"]
  end

  test "that write should allow all default options" do
    lines = CSV.write([["a", "b"], ["1", "2"]]) |> Enum.to_list
    assert lines == ["a,b\r\n", "1,2\r\n"]
  end
end
