defmodule CSV.Dumper do
  alias NimbleCSV.RFC4180, as: Formatter

  def dump(stream, path) do
    dump(stream) |> Enum.into(File.stream!(path))
  end

  def dump(stream) do
    stream
    |> to_values
    |> to_csv
  end

  def to_values(stream) do
    Stream.transform(stream, 0, fn struct, index -> { row_values(struct, index), index + 1 } end )
  end

  defp to_csv(stream) do
    stream
    |> Formatter.dump_to_stream
    |> Stream.map(&IO.iodata_to_binary(&1))
  end

  defp row_values(struct, index) do
    headers    = headers(struct)
    row_values = struct_to_values(struct, headers)

    case index do
      0 -> [headers, row_values]
      _ -> [row_values]
    end
  end

  defp struct_to_values(struct, headers) do
    Enum.map(headers, &struct_value(struct, &1))
  end

  defp struct_value(struct, key) do
    Map.get(struct, String.to_atom(key)) || ""
  end

  defp headers(struct) do
    schema  = struct.__struct__
    columns = schema.__csv__(:columns)
    Enum.map(columns, &Kernel.to_string/1)
  end
end
