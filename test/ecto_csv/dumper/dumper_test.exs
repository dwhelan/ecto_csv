defmodule EctoCSV.Dumper.DumperTest do
  use ExUnit.Case

  defmodule Example do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b, :integer
      field :c, :float
    end

    csv do
    end
  end

  describe "dump" do
    test "header is created" do
      assert ["a,b,c\r\n", _] = dump(%Example{})
    end

    test "fields with no data type should be dumped as empty strings" do
      assert [_, ",,\r\n"] = dump(%Example{})
    end

    test "fields with a data type should be dumped as their type" do
      assert [_, ",2,3.4\r\n"] = dump(%Example{b: 2, c: 3.4})
    end

    test "double quotes are preserved in strings" do
      assert [_, ~s{" ""hi"" there",,\r\n}] = dump(%Example{a: ~s{ "hi" there}})
    end

    test "that records can be dumped to files" do
      path = TestFile.create();
      EctoCSV.Dumper.dump([%Example{a: "hi", b: 2, c: 3.4}, %Example{a: "there", b: 5, c: 6.7}], path)
      assert {:ok, "a,b,c\r\nhi,2,3.4\r\nthere,5,6.7\r\n"} = File.read(path)
    end
  end

  defp dump(lines) do
    EctoCSV.Dumper.dump(List.wrap(lines)) |> Enum.to_list
  end
end
