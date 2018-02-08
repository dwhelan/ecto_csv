defmodule EctoCSV.Dumper do
  alias EctoCSV.Adapters.CSV

  @spec dump(Stream.t, binary) :: Collectable.t
  def dump(stream, path) do
    dump(stream) |> Enum.into(File.stream!(path))
  end

  @spec dump(Stream.t) :: Stream.t
  def dump(stream) do
    schema = extract_schema(stream)

    stream
    |> to_values(schema)
    |> write(schema)
  end

  @spec extract_schema(Stream.t) :: EctoCSV.Schema
  defp extract_schema(stream) do
    Enum.take(stream , 1) |> List.first |> schema
  end

  @spec to_values(Stream.t, EctoCSV.Schema) :: Stream.t
  defp to_values(stream, schema) do
    Stream.transform(stream, 0, fn struct, index -> 
      {row_values(struct, index, schema), index + 1}
    end)
  end

  @spec write(Stream.t, EctoCSV.Schema) :: Stream.t
  defp write(stream, schema) do
    CSV.write(stream, options(schema))
  end

  @spec row_values(Stream.t, integer, EctoCSV.Schema) :: Stream.t
  defp row_values(struct, index, schema) do
    row_values(struct, index, schema, file_has_header?(schema))
  end

  @spec row_values(Stream.t, 0, EctoCSV.Schema, true) :: Stream.t
  defp row_values(struct, 0, schema, true) do
    [keys(struct, schema), row_values(struct, schema)]
  end

  defp row_values(struct, _, schema, _) do
    [row_values(struct, schema)]
  end

  # This spec might be wrong
  @spec row_values(Stream.t, EctoCSV.Schema) :: Stream.t
  defp row_values(struct, schema) do
    Enum.map(keys(struct, schema), &struct_value(struct, &1))
  end

  defp struct_value(struct, field) do
    Map.get(struct, field) || ""
  end

  @spec options(EctoCSV.Schema) :: Keyword.t
  defp options(schema) do
    [
      separator: separator(schema),
      delimiter: delimiter(schema)
    ]
  end

  defp keys(struct, schema) do
    keys(struct, headers(schema), extra_columns(schema))
  end

  defp keys(struct, schema_headers, :retain) do
    schema_headers ++ (Map.keys(struct) |> reject_meta_keys) -- schema_headers
  end

  defp keys(_struct, schema_headers, _) do
    schema_headers
  end

  defp schema(struct) do
    struct.__struct__
  end

  @spec file_has_header?(EctoCSV.Schema) :: boolean
  defp file_has_header?(schema) do
    schema.__csv__ :file_has_header?
  end

  @spec headers(EctoCSV.Schema) :: [atom]
  defp headers(schema) do
    schema.__csv__ :headers
  end

  @spec extra_columns(EctoCSV.Schema) :: atom
  defp extra_columns(schema) do
    schema.__csv__ :extra_columns
  end

  @spec separator(EctoCSV.Schema) :: String.t
  defp separator(schema) do
    schema.__csv__ :separator
  end

  @spec delimiter(EctoCSV.Schema) :: String.t
  defp delimiter(schema) do
    schema.__csv__ :delimiter
  end

  defp reject_meta_keys keys do
    Enum.reject keys, &meta_key?(&1)
  end

  defp meta_key?(key) when is_atom(key),   do: key == :id or meta_key? Atom.to_string(key)
  defp meta_key?(key),                     do: Regex.match? ~r/^__/, key
end
