defmodule CSV.Dumper do
  alias NimbleCSV.RFC4180, as: Formatter

  def dump(stream, schema, path) do
    output = File.stream!(path)
    dump(stream, schema)
    |> Enum.into(output)
  end

  def dump(stream, schema) do
    header = Enum.map(schema.__csv__(:columns), &Kernel.to_string/1)

    insert_header(stream, header)
    |> Stream.map(fn line -> dump_row(line, header) end)
    |> format
    |> Stream.map(fn line -> IO.iodata_to_binary(line) end)
  end

  defp insert_header(stream, header) do
    [:_, :stream]
    |> Stream.transform(:insert_header, fn _, what_to_stream ->
        case what_to_stream do
          :insert_header -> { [header], :stream }
          :stream        -> { stream, :stream}
        end
      end )
  end

  defp dump_row(row, _headers) when is_list(row) do
    row
  end

  defp dump_row(row, header) do
    Enum.map(header, fn header -> Map.get(row, String.to_atom(header)) || "" end)
  end

  defp format(stream) do
    Formatter.dump_to_stream(stream)
  end
end
