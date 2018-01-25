defmodule EctoCSV.Dumper.DelimiterTest do
  use ExUnit.Case

  defmodule ExamplePipe do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b, :integer
    end

    csv do
      delimiter  "|"      
    end 
  end
  
  test "header is created with pipes" do
    assert ["a|b\n", _] = dump(%ExamplePipe{})
  end

  defp dump(lines) do
    EctoCSV.Dumper.dump(List.wrap(lines)) |> Enum.to_list
  end

end
