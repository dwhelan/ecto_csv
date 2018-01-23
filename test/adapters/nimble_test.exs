defmodule EctoCSV.Adapters.NimbleTest do
  alias EctoCSV.Adapters.Nimble

  use ExUnit.Case

  describe "decode" do
    test "that it should decode with comma as the delimiter" do
      lines = Nimble.decode(["a,b", "1,2"], %{}) |> Enum.to_list
      assert lines == [["a", "b"], ["1", "2"]]
    end
  end
end
