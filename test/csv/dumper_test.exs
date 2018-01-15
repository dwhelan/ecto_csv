defmodule CSV.DumperTest do
  use ExUnit.Case

  defmodule Example do
    use CSV.Schema

    columns do
      column :a
      column :b, :integer
    end
  end

  describe "dump" do
    test "columns with no data type should be dumped as strings" do
      assert dump(%Example{a: "A"}) == ["a,b\n", "A,\n"]
    end

    test "columns with a data type should be dumped as their type" do
      assert dump(%Example{b: 1}) == ["a,b\n", ",1\n"]
    end

    test "double quotes are preserved in strings" do
      assert dump(%Example{a: ~s{ "hi" there}}) == ["a,b\n", ~s{" ""hi"" there",\n}]
    end

    test "that structs can be dumped to files" do
      path = TestFile.create();
      CSV.Dumper.dump([%Example{a: "1", b: 2}, %Example{a: "4", b: 5}], path)
      assert {:ok, "a,b\n1,2\n4,5\n"} = File.read(path)
    end
  end

  defp dump(lines) do
    CSV.Dumper.dump(List.wrap(lines)) |> Enum.to_list
  end
end
