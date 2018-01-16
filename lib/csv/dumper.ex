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
    if index == 0 && dump_headers?(struct) do
      [header_values(struct), row_values(struct)]
    else
      [row_values(struct)]
    end
  end

  defp dump_headers?(struct) do
    mod = struct.__struct__
    if Keyword.has_key?(mod.__info__(:functions), :__csv__) do
      mod.__csv__(:headers)
    else
      true
    end
  end

  defp row_values(struct) do
    Enum.map(header_values(struct), &struct_value(struct, &1))
  end

  defp struct_value(struct, field) do
    Map.get(struct, field) || ""
  end

  defp header_values(struct) do
    mod  = struct.__struct__    
    mod.__schema__(:fields)
    |> Enum.filter(&(&1 != :id))
  end
end
