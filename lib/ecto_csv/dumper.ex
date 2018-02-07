defmodule EctoCSV.Dumper do
  alias EctoCSV.Adapters.CSV

  def dump(stream, path) do
    dump(stream) |> Enum.into(File.stream!(path))
  end

  def dump(stream) do
    schema = extract_schema(stream)

    stream
    |> to_values(schema)
    |> write(schema)
  end

  defp extract_schema(stream) do
    Enum.take(stream , 1) |> List.first |> schema
  end

  defp to_values(stream, schema) do
    Stream.transform(stream, 0, fn struct, index -> {row_values(struct, index, schema), index + 1} end )
  end

  defp write(stream, schema) do
    CSV.write(stream, options(schema))
  end

  defp row_values(struct, index, schema) do
    if index == 0 && file_has_header?(schema) do
      [headers(schema), row_values(struct, schema)]
    else
      [row_values(struct, schema)]
    end
  end

  defp row_values(struct, schema) do
    Enum.map(headers(schema), &struct_value(struct, &1))
  end

  defp struct_value(struct, field) do
    Map.get(struct, field) || ""
  end

  defp options(schema) do
    [
      separator: separator(schema),
      delimiter: delimiter(schema)
    ]
  end

  defp schema(struct) do
    struct.__struct__
  end

  defp file_has_header?(schema) do
    schema.__csv__ :file_has_header?
  end

  defp headers(schema) do
    schema.__csv__ :headers
  end

  defp separator(schema) do
    schema.__csv__ :separator
  end

  defp delimiter(schema) do
    schema.__csv__ :delimiter
  end

  defp meta_key?(:id),                     do: true
  defp meta_key?(key) when is_atom(key),   do: meta_key? Atom.to_string(key)
  defp meta_key?(key) when is_binary(key), do: Regex.match? ~r/^__/, key
end
