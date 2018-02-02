defmodule EctoCSV.Loader.StreamTest do
  require Briefly
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

  describe "load from stream" do
    test "fields with no data type gets a type of 'string'" do
      assert [%Example{a: "1"}] = load(["a", "1"])
    end

    test "values are converted to the defined data type" do
      assert [%Example{b: 2}] = load(["a,b", "1,2"])
    end

    test "multiple rows can be loaded" do
      assert [%Example{a: "1"}, %Example{a: "2"}] = load(["a", "1", "2"])
    end

    test "multiple fields per row can be loaded" do
      assert [%{a: "1", b: 2, c: 3.45}] = load ["a,b,c", "1,2,3.45"]
    end

    test "white space is preserved in strings" do
      assert [%{a: " 1 "}] = load ["a,b,c", " 1 ,2,3.45"]
    end

    test "double quotes are preserved in strings" do
      assert [%{a: ~s{ "hi" there}}] = load ["a,b,c", ~s{" ""hi"" there",2,3.45}]
    end
  end

  test "should stream from a file" do
    assert [%{a: "1", b: 2, c: 3.45}] = load(TestFile.create("a,b,c\n1,2,3.45"))
  end

  defp load(lines) do
    EctoCSV.Loader.load(lines, Example) |> Enum.to_list
  end
end
