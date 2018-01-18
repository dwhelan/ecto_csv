defmodule DataConv.Test do
  use ExUnit.Case
  
  defmodule Source do
    use EctoCSV.Schema

    schema "source" do
      field :a
      field :b, :integer
      field :c, :float
    end

    csv()
  end

  test "streaming: input csv -> process -> ouptut should retain data" do
    input  = ["a,b,c\n", "d,1,2.3\n", "e,4,5.6\n"]
    output = DataConv.process(input, Source) |> Enum.to_list
    assert output == input
  end

  test "file: input csv -> process -> ouptut should retain data" do
    input = "a,b,c\nd,1,2.3\ne,4,5.6\n"
    {source, destination} = TestFile.create_pair(input);
    DataConv.process(source, destination, Source)
    {:ok, output} = File.read(destination)
    assert output == input
  end
end
