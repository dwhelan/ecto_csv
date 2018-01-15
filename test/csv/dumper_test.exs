defmodule CSV.DumperTest do
  use ExUnit.Case

  defmodule Example do
    use CSV.Schema

    columns do
      column :a
      column :b, :integer
      column :c, :float
    end
  end

  describe "dump" do
    test "header is created" do
      assert ["a,b,c\n", _] = dump(%Example{})
    end

    test "columns with no data type should be dumped as empty strings" do
      assert [_, ",,\n"] = dump(%Example{})
    end

    test "columns with a data type should be dumped as their type" do
      assert [_, ",2,3.4\n"] = dump(%Example{b: 2, c: 3.4})
    end

    test "double quotes are preserved in strings" do
      assert [_, ~s{" ""hi"" there",,\n}] = dump(%Example{a: ~s{ "hi" there}})
    end

    test "that structs can be dumped to files" do
      path = TestFile.create();
      CSV.Dumper.dump([%Example{a: "hi", b: 2, c: 3.4}, %Example{a: "there", b: 5, c: 6.7}], path)
      assert {:ok, "a,b,c\nhi,2,3.4\nthere,5,6.7\n"} = File.read(path)
    end
  end

  defp dump(lines) do
    CSV.Dumper.dump(List.wrap(lines)) |> Enum.to_list
  end
end
