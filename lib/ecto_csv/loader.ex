defmodule EctoCSV.Loader do
  alias Ecto.Type
  alias EctoCSV.Adapters.CSV
  alias EctoCSV.LoadError
  alias EctoCSV.Loader.Header

  @moduledoc """
  Loads CSV data using an `Ecto.Schema` to describe the data.

  The data must be compliant with [RFC4180](https://tools.ietf.org/html/rfc4180).
  """

  @doc """
  Load CSV data from the file at `path` returning a stream of structs as defined by the `schema`.
  """
  def load(path, schema) when is_binary(path) do
    load(File.stream!(path), schema)
  end

  @doc """
  Load CSV data from the `stream` returning a stream of structs as defined by the `schema`.

  """
  def load(stream, schema) do
    stream
    |> extract_headers(schema)
    |> decode(schema)
    |> validate_row(schema)
    |> create_key_value_tuples(schema)
    |> load_row(schema)
  end

  defp extract_headers(stream, schema) do
    Header.extract_headers(stream, schema)
  end

  defp decode({stream, headers}, schema) do
    {CSV.decode(stream, schema), headers}
  end

  defp validate_row({stream, headers}, schema) do
    if length(headers) > length(headers(schema)) and extra_columns(schema) == :error do
      extras = Enum.join(headers -- headers(schema), ",")
      raise LoadError.exception(line: 1, message: "extra headers '#{extras}' found")
    end
    {stream, headers}
  end

  defp create_key_value_tuples({stream, headers}, schema) do
    Stream.map(stream, fn values ->
      values = maybe_remove_extra_values(values, headers, extra_columns(schema))
      keys   = maybe_add_extra_keys(values, headers, extra_columns(schema))
      
      Enum.zip(keys, values)
    end)
  end

  defp maybe_remove_extra_values(values, headers, :ignore) do
    remove_extra_values(headers, values)
  end

  defp maybe_remove_extra_values(values, _, _) do
    values
  end

  defp maybe_add_extra_keys(_, headers, :ignore) do
    headers
  end

  defp maybe_add_extra_keys(values, headers, _) do
    create_headers_with_extras(headers, values)
  end

  defp remove_extra_values([], values) do
    values
  end

  defp remove_extra_values(headers, values) do
    Enum.take values, length(headers)
  end

  defp create_headers_with_extras(headers, values) do
    extra_headers = for i <- length(headers)..length(values), do: to_atom("Field#{i+1}")
    headers ++ extra_headers
  end

  defp load_row(stream, schema) do
    Stream.map(stream, fn tuples -> 
      tuples |> Enum.reduce(struct(schema), &load_value(&1, &2, schema))
    end)
  end

  defp load_value({field, value}, struct, schema) do
    if Enum.member?(headers(schema), field) || extra_columns(schema) == :retain do
      {:ok, value} = Type.cast(type(schema, field), value)
      Map.put(struct, field, value)
    else
      struct
    end
  end

  defp headers(schema) do
    schema.__csv__ :headers
  end

  defp extra_columns(schema) do
    schema.__csv__ :extra_columns
  end

  defp type(schema, field) do
    schema.__schema__(:type, field) || :string
  end

  defp to_atom(list) when is_list(list) do
    list |> Enum.map(&to_atom(&1))
  end

  defp to_atom(string) when is_binary(string) do
    try do
      String.to_existing_atom(string)
    rescue ArgumentError -> 
      String.to_atom(string)
    end
  end
end
