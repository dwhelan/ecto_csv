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

  defp to_values(stream) do
    Stream.transform(stream, 0, fn struct, index -> {row_values(struct, index), index + 1} end )
  end

  defp to_csv(stream) do
    stream
    |> Formatter.dump_to_stream
    |> Stream.map(&IO.iodata_to_binary(&1))
  end

  defp row_values(struct, index) do
    case index do
      0 -> [header_values(struct), row_values(struct)]
      _ -> [row_values(struct)]
    end
  end

  defp row_values(struct) do
    Enum.map(header_values(struct), &struct_value(struct, &1))
  end

  defp struct_value(struct, key) do
    Map.get(struct, String.to_atom(key)) || ""
  end

  defp header_values(struct) do
    schema  = struct.__struct__
    columns = schema.__csv__(:columns)
    Enum.map(columns, &Kernel.to_string/1)
  end
end
