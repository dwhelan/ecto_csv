defmodule CSV.Dumper do
  alias NimbleCSV.RFC4180, as: Formatter

  def dump(stream, schema, path) do
    output = File.stream!(path)
    dump(stream, schema)
    |> Enum.into(output)
  end

  def dump(stream, schema) do
    headers = Enum.map(schema.__csv__(:columns), &Kernel.to_string/1)

    [:_, :stream]
    |> Stream.transform(:insert_header, fn _, what_to_stream ->
        case what_to_stream do
          :insert_header -> { [headers], :stream }
          :stream        -> { stream, :stream}
        end
      end )
    |> Stream.map(fn line -> dump_row(line, headers) end)
    |> format
    |> Stream.map(fn line -> IO.iodata_to_binary(line) end)
  end

  defp dump_row(row, _headers) when is_list(row) do
    row
  end

  defp dump_row(row, headers) do
    Enum.map(headers, fn header -> Map.get(row, String.to_atom(header)) || "" end)
  end

  defp format(stream) do
    Formatter.dump_to_stream(stream)
  end
end
