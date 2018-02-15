defmodule EctoCSV.Dumper do
  alias EctoCSV.Adapters.CSV
  import EctoCSV.SchemaHelper

  @moduledoc """
  Exports data to a file using an 'Ecto.Schema' to describe the data.
  """

  @doc """
  Writes stream of data to a file named 'path' and returns the file once 
  written.
  """
  @spec dump(Stream.t, binary) :: Collectable.t
  def dump(stream, path) do
    stream |> dump |> Enum.into(File.stream!(path))
  end

  @doc """
  Extracts schema and formats the stream of information 
  using the delimiters and separators specified in the
  schema.
  """
  @spec dump(Stream.t) :: Stream.t
  def dump(stream) do
    schema = extract_schema(stream)

    stream
    |> to_values(schema)
    |> write(schema)
  end

  @spec extract_schema(Stream.t) :: EctoCSV.Schema
  defp extract_schema(stream) do
    stream |> Enum.take(1) |> List.first |> schema
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
    schema_headers ++ (struct |> Map.keys |> reject_meta_keys) -- schema_headers
  end

  defp keys(_struct, schema_headers, _) do
    schema_headers
  end

  defp schema(struct) do
    struct.__struct__
  end

  defp reject_meta_keys keys do
    Enum.reject keys, &meta_key?(&1)
  end

  defp meta_key?(key) when is_atom(key),   do: key == :id or meta_key? Atom.to_string(key)
  defp meta_key?(key),                     do: Regex.match? ~r/^__/, key
end
