defmodule CSV.LoaderTest do
  require Briefly

  use ExUnit.Case
  
  defmodule Example do
    use CSV.Schema

    columns do
      column :a
      column :b, :integer
      column :c, :float
    end
  end

  describe "load" do
    test "columns with no data type gets a type of 'string'" do
      assert %Example{a: "1"} = load_one(["a", "1"])
    end

    test "values are converted to the defined data type" do
      assert %Example{b: 1} = load_one(["b", "1"])
    end

    test "should ignore fields not defined in the schema" do
      refute load_one(["x", "1"]) |> Map.has_key?(:x)
    end

    test "that multiple rows can be loaded" do
      assert load_all(["a", "1", "2"]) |> length == 2
    end

    test "that multiple fields in a row can be loaded" do
      assert %{a: "1", b: 2, c: 1.23} = load_one ["a,b,c", "1,2,1.23"]
    end

    test "that structs can be loaded from files" do
      assert %{a: "1", b: 2, c: 3.0} = load_one(TestFile.create("a,b,c\n1,2,3"))
    end
  end

  defp load_one(lines) do
    hd(load(lines, 1))
  end
  
  defp load_all(lines) do
    load(lines) |> Enum.to_list
  end
  
  defp load(lines, count) do
    load(lines) |> Enum.take(count)
  end
  
  defp load(lines) do
    CSV.Loader.load(lines, Example)
  end
end
