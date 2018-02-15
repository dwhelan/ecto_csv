defmodule EctoCSV.Dumper.SeparatorTest do
  use ExUnit.Case

  defmodule ExamplePipe do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      separator "|"
    end 
  end
  
  test "dumped values are separated by separator" do
    assert ["a|b\r\n", "1|2\r\n"] = dump(%ExamplePipe{a: "1", b: "2"})
  end

  defp dump(lines) do
    lines |> List.wrap |> EctoCSV.Dumper.dump |> Enum.to_list
  end
end
