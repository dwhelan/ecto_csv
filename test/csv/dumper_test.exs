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
      assert dump_one(a: "A") == ["a,b\n", "A,\n"]
    end

    test "columns with a data type should be dumped as their type" do
      assert dump_one(b: 1) == ["a,b\n", ",1\n"]
    end

    @tag :skip
    test "that structs can be dumped to files" do
      structs = [%{a: "1", b: 2, c: 3.0}, %{a: "4", b: 5, c: 6.0}] 
      path = TestFile.create();
      CSV.Dumper.dump(structs, Example, path)
      assert File.read(path) == "ss"
    end
  end

  defp dump_one(opts) do
    struct(Example, opts) |> dump
  end

  defp dump(lines) do
    CSV.Dumper.dump(List.wrap(lines), Example) |> Enum.to_list
  end
end
