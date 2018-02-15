defmodule EctoCSV.Adapters.CSVTest do
  alias EctoCSV.Adapters.CSV

  use ExUnit.Case

  describe "that read" do
    test "should support a comma separator" do
      lines = ["a,b", "1,2"] |> CSV.read(separator: ",") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should support tab separator" do
      lines = ["a\tb", "1\t2"] |> CSV.read(separator: "\t") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should support '|' separator" do
      lines = ["a|b", "1|2"] |> CSV.read(separator: "|") |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should default to a comma separator and a '\\r\\n' delimiter" do
      lines = ["a,b\r\n", "1,2\r\n"] |> CSV.read |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end

    test "should handle a '\\n' delimiter by default" do
      lines = ["a,b\n", "1,2\n"] |> CSV.read |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end
  end

  describe "that write with a delimiter of '\\r\\n'" do
    test "should support a comma separator" do
      lines = [["a", "b"], ["1", "2"]] |> CSV.write(separator: ",", delimiter: "\r\n") |> Enum.to_list
      assert lines == ["a,b\r\n", "1,2\r\n"]
    end

    test "should support a tab separator" do
      lines = [["a", "b"], ["1", "2"]] |> CSV.write(separator: "\t", delimiter: "\r\n") |> Enum.to_list
      assert lines == ["a\tb\r\n", "1\t2\r\n"]
    end

    test "should support a '|' separator" do
      lines = [["a", "b"], ["1", "2"]] |> CSV.write(separator: "|", delimiter: "\r\n") |> Enum.to_list
      assert lines == ["a|b\r\n", "1\|2\r\n"]
    end
  end

  describe "that write with delimiter of '\\n'" do
    test "should support a comma separator" do
      lines = [["a", "b"], ["1", "2"]] |> CSV.write(separator: ",", delimiter: "\n") |> Enum.to_list
      assert lines == ["a,b\n", "1,2\n"]
    end

    test "should support a tab separator" do
      lines = [["a", "b"], ["1", "2"]] |> CSV.write(separator: "\t", delimiter: "\n") |> Enum.to_list
      assert lines == ["a\tb\n", "1\t2\n"]
    end

    test "should support a '|' separator" do
      lines = [["a", "b"], ["1", "2"]] |> CSV.write(separator: "|", delimiter: "\n") |> Enum.to_list
      assert lines == ["a|b\n", "1\|2\n"]
    end
  end
  
  test "that write should default delimiter to '\\r\\n'" do
    lines = [["a", "b"], ["1", "2"]] |> CSV.write(separator: ",") |> Enum.to_list
    assert lines == ["a,b\r\n", "1,2\r\n"]
  end

  test "that write should default separator to a comma" do
    lines = [["a", "b"], ["1", "2"]] |> CSV.write(delimiter: "\r\n") |> Enum.to_list
    assert lines == ["a,b\r\n", "1,2\r\n"]
  end

  test "that write should allow all default options" do
    lines = [["a", "b"], ["1", "2"]] |> CSV.write |> Enum.to_list
    assert lines == ["a,b\r\n", "1,2\r\n"]
  end
end
