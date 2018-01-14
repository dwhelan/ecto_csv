defmodule CSV.Dumper do

  def dump(stream, schema) do
    headers = Enum.map(schema.__csv__(:columns), &Kernel.to_string/1)

    1..2
    |> Stream.transform(1, fn _, index ->
        case index do
          1 -> { [headers], 2 }
          _ -> { stream, index + 1}
        end
      end )
    |> Stream.map(fn line -> dump_row(line, headers) end)
  end

  defp dump_row(row, _headers) when is_list(row) do
    row
  end

  defp dump_row(row, headers) do
    Enum.map(headers, fn header -> Map.get(row, String.to_atom(header)) || "" end)
  end
end
