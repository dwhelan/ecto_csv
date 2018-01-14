defmodule CSV.Dumper do
  alias NimbleCSV.RFC4180, as: Formatter

  def dump(stream, schema, path) do
    output = File.stream!(path)
    dump(stream, schema)
    |> Enum.into(output)
  end

  def dump(stream, schema) do
    stream
    |> transform_to_list
    |> transform_to_csv_string
  end

  defp header(schema) do
    Enum.map(schema.__csv__(:columns), &Kernel.to_string/1)
  end

  defp header_list(data) do
    header(data.__struct__)
  end

  defp row_list(data) do
    header = header_list(data)
    Enum.map(header, fn header -> Map.get(data, String.to_atom(header)) || "" end)
  end

  def transform_to_list(stream) do
    Stream.transform(stream, 0, fn data, index ->
      if index == 0 do
        {[header_list(data), row_list(data)], index + 1}
      else
        {[row_list(data)], index + 1}
      end
    end )
  end

  defp transform_to_csv_string(stream) do
    stream
    |> Formatter.dump_to_stream
    |> Stream.map(&IO.iodata_to_binary(&1))
  end
end

