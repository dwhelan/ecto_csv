defmodule DataConv.CLITest do
  use ExUnit.Case
  doctest DataConv

  test "main [] should raise" do
    assert_raise RuntimeError, fn -> DataConv.CLI.main [] end
  end

  test "main [input] should raise" do
    assert_raise RuntimeError, fn -> DataConv.CLI.main ["input"] end
  end

  test "main [input, output] should process the file" do
    DataConv.CLI.main ["test/files/simple.csv", "test/files/out.csv"]
  end
end
