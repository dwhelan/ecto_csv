defmodule CSV.IntegrationTest do
  use ExUnit.Case

  defmodule Example do
    use CSV.Schema

    columns do
      column :a
      column :b, :integer
      column :c, :float
    end
  end

  describe "loading and then dumping retains values" do
    test "via files" do
      in_content = "a,b,c\n1,2,3.45\n7,8,9.1\n"
      in_path    = TestFile.create(in_content);
      out_path   = TestFile.create();

      CSV.Loader.load(in_path, Example) |> CSV.Dumper.dump(out_path)

      {:ok, out_content} = File.read(out_path)
      assert out_content == in_content
    end
  end
end
