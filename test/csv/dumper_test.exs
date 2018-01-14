defmodule CSV.DumperTest do
  use ExUnit.Case

  defmodule File do
    use CSV.Schema

    columns do
      column :a
      column :b, :integer
    end
  end

  describe "dump" do
    test "columns with no data type should be dumped as strings" do
      assert dump_one(a: "A") == [["a", "b"], ["A", ""]]
    end

    test "columns with a data type should be dumped as their type" do
      assert dump_one(b: 1) == [["a", "b"], ["", 1]]
    end
  end

  defp dump_one(opts) do
    dump(record(opts))
  end

  defp dump(lines) do
    CSV.Dumper.dump(List.wrap(lines), CSV.DumperTest.File) |> Enum.to_list
  end
  
  defp record(opts) do
    struct(CSV.DumperTest.File, opts)
  end
end
