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
    test "header is created" do
      assert ["a,b\n", _] = dump(%Example{})
    end

    test "columns with no data type should be dumped as strings" do
      assert [_, "A,\n"] = dump(%Example{a: "A"})
    end

    test "columns with a data type should be dumped as their type" do
      assert [_, ",1\n"] = dump(%Example{b: 1})
    end

    test "double quotes are preserved in strings" do
      assert [_, ~s{" ""hi"" there",\n}] = dump(%Example{a: ~s{ "hi" there}})
    end

    test "that structs can be dumped to files" do
      path = TestFile.create();
      CSV.Dumper.dump([%Example{a: "1", b: 2}, %Example{a: "3", b: 4}], path)
      assert {:ok, "a,b\n1,2\n3,4\n"} = File.read(path)
    end
  end

  defp dump(lines) do
    CSV.Dumper.dump(List.wrap(lines)) |> Enum.to_list
  end
end
