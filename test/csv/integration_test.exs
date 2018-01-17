defmodule CSV.IntegrationTest do
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

  describe "loading and then dumping retains values" do
    test "via files" do
      content = "a,b,c\n 1 ,2,3.45\n6,7,8.1\n"
      # IO.inspect Example.__info__(:functions)
      assert load_and_dump(content) == content
    end

    test "white spaces and double quotes are preserved" do
      content = ~s{a,b,c\n" ""hi"" there",1,2.3\n}
      assert load_and_dump(content) == content
    end
  end

  defp load_and_dump(content) do
    in_path  = TestFile.create(content);
    out_path = TestFile.create();

    CSV.Loader.load(in_path, Example) |> CSV.Dumper.dump(out_path)

    {:ok, content} = File.read(out_path)
    content
  end
end
