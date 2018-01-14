defmodule CSV.LoaderTest do
  require Briefly

  use ExUnit.Case
  
  defmodule Example do
    use CSV.Schema

    columns do
      column :a
      column :b, :integer
    end
  end

  describe "load" do
    test "columns with no data type gets a type of 'string'" do
      record = load_one [["a"], ["1"]]
      assert record.a == "1"
    end

    test "values are converted to the defined data type" do
      record = load_one [["b"], ["1"]]
      assert record.b == 1
    end

    test "should dynamically add unknown columns to the record as a string" do
      record = load_one [["X"], ["seven"]]
      assert record."X" == "seven"
    end

    test "that multiple rows can be loaded" do
      records = load_all [["a"], ["1"], ["2"]]
      assert length(records) == 2
    end

    test "that multiple fields in a row can be loaded" do
      record = load_one [["a", "b"], ["1", "2"]]
      assert record.a == "1"
      assert record.b == 2
    end

    test "that records can be read from a file" do
      path = create_test_file """
      A,B,C
      1,2,3
      """
      records = load_all(path)
      assert records == ""
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
