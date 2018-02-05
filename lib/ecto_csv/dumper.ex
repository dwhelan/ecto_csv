defmodule EctoCSV.Dumper do
  alias EctoCSV.Adapters.CSV

  def dump(stream, path) do
    dump(stream) |> Enum.into(File.stream!(path))
  end

  def dump(stream) do
    schema = extract_schema(stream)
    stream
    |> to_values
    |> write(schema)
  end

  defp to_values(stream) do
    Stream.transform(stream, 0, fn struct, index -> {row_values(struct, index), index + 1} end )
  end

  defp extract_schema(stream) do
    struct = hd(Enum.take(stream , 1))
    struct.__struct__
  end  

  defp write(stream, schema) do
    CSV.write(stream, options(schema))
  end

  defp row_values(struct, index) do
    schema = struct.__struct__

    if index == 0 && schema.__csv__(:file_has_header?) do
      [schema.__csv__(:headers), row_values(struct)]
    else
      [row_values(struct)]
    end
  end

  defp row_values(struct) do
    schema = struct.__struct__
    Enum.map(schema.__csv__(:headers) |> reject_meta_keys, &struct_value(struct, &1))
  end

  defp row_values2(struct) do
    schema = struct.__struct__
    Enum.map(schema.__csv__(:headers), &struct_value(struct, &1))
  end

  defp struct_value(struct, field) do
    Map.get(struct, field) || ""
  end

  defp reject_meta_keys keys do
    Enum.reject keys, &meta_key?(&1)
  end

  defp options(schema) do
    [
      separator: separator(schema),
      delimiter: delimiter(schema)
    ]
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
