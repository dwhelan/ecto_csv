defmodule EctoCSV.Adapters.CSVTest do
  alias EctoCSV.Adapters.CSV

  use ExUnit.Case

  describe "decode" do
    test "that it should load a valid stream" do
      lines = CSV.decode(["a,b", "1,2"], %{}) |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end
  end
end
