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
      record = load_one ["a,x", "1,2"]
      assert %Example{a: "1"} = record
      assert !Map.has_key?(record, :x)
    end

    test "that multiple rows can be loaded" do
      records = load_all ["a", "1", "2"]
      assert length(records) == 2
    end

    test "that multiple fields in a row can be loaded" do
      assert %{a: "1", b: 2, c: 1.23} = load_one ["a,b,c", "1,2,1.23"]
    end

    test "that records can be read from a file" do
      path = create_test_file "a,b,c\n1,2,3"
      assert %{a: "1", b: 2, c: 3.0} = load_one(path)
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
    CSV.Loader.load(lines, CSV.LoaderTest.Example)
  end

  defp create_test_file(content) do
    path = Briefly.create!
    File.write!(path, content)
    path
  end
end
