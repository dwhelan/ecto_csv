defmodule CSV.DumperTest do
  use ExUnit.Case

  defmodule Example do
    use CSV.Schema

    schema "test" do
      field :a
      field :b, :integer
      field :c, :float
    end

    csv()
  end

  describe "dump" do
    test "header is created" do
      assert ["a,b,c\n", _] = dump(%Example{})
    end

    test "fields with no data type should be dumped as empty strings" do
      assert [_, ",,\n"] = dump(%Example{})
    end

    test "fields with a data type should be dumped as their type" do
      assert [_, ",2,3.4\n"] = dump(%Example{b: 2, c: 3.4})
    end

    test "double quotes are preserved in strings" do
      assert [_, ~s{" ""hi"" there",,\n}] = dump(%Example{a: ~s{ "hi" there}})
    end

    test "that records can be dumped to files" do
      path = TestFile.create();
      CSV.Dumper.dump([%Example{a: "hi", b: 2, c: 3.4}, %Example{a: "there", b: 5, c: 6.7}], path)
      assert {:ok, "a,b,c\nhi,2,3.4\nthere,5,6.7\n"} = File.read(path)
    end
  end

  defmodule ExampleWithHeaders do
    use CSV.Schema
    
    schema "test" do
      field :a
    end

    csv do
      header true
    end
  end

  describe "dump with headers set to 'true'" do
    test "header is dumped" do
      assert ["a\n", "1\n"] = dump(%ExampleWithHeaders{a: "1"})
    end
  end

  defmodule ExampleWithoutHeaders do
    use CSV.Schema

    schema "test" do
      field :a
    end

    csv do
      header false
    end
  end

  describe "dump with headers set to 'false'" do
    test "header is not dumped" do
      assert ["1\n"] = dump(%ExampleWithoutHeaders{a: "1"})
    end
  end

  defp dump(lines) do
    CSV.Dumper.dump(List.wrap(lines)) |> Enum.to_list
  end
end
