defmodule EctoCSV.Loader do
  alias Ecto.Type
  alias EctoCSV.Adapters.CSV
  require EctoCSV.Adapters.Nimble, as: CSV
  alias EctoCSV.LoadError
  alias EctoCSV.Loader.Header

  @moduledoc """
  Loads CSV data using an `Ecto.Schema` to describe the data.

  The data must be compliant with [RFC4180](https://tools.ietf.org/html/rfc4180).
  """

  @doc """
  Load CSV data from the file at `path` returning a stream of structs as defined by the `schema`.
  """
  @spec load(String | Stream.t, EctoCSV.Schema) :: Stream.t
  def load(path, schema) when is_binary(path) do
    load(File.stream!(path), schema)
  end

  @doc """
  Load CSV data from the `stream` returning a stream of structs as defined by the `schema`.

  """
  def load(stream, schema) do
    {stream, headers} = extract_headers(stream, schema)

    stream
    |> read(schema)
    |> validate_row(headers, schema)
    |> create_key_value_tuples(headers, schema)
    |> load_row(schema)
  end

  @spec extract_headers(Stream.t, EctoCSV.Schema) :: Stream.t
  defp extract_headers(stream, schema) do
    if file_has_header?(schema) do
      {Header.remove_header(stream), Header.file_headers(stream, schema)}
    else
      {stream, headers(schema)}
    end
  end

  @spec read(Stream.t, EctoCSV.Schema) :: Stream.t
  defp read(stream, schema) do
    CSV.read(stream, options(schema))
  end

  @spec options(EctoCSV.Schema) :: Keyword.t
  defp options(schema) do
    [
      separator: separator(schema),
      delimiter: delimiter(schema)
    ]
  end

  @spec validate_row(Stream.t, [atom], EctoCSV.Schema) :: any
  defp validate_row(stream, headers, schema) do
    line_offset = case file_has_header?(schema) do
      true  -> 2
      false -> 1
    end

    stream
    |> Stream.with_index(line_offset)
    |> Stream.map(fn {values, line} ->
      if length(values) > length(headers) and extra_columns(schema) == :error do
        extras = Enum.drop(values, length(headers))
        raise LoadError.exception(line: line, message: "extra fields '#{extras}' found")
      end
      values
    end)
  end

  @spec create_key_value_tuples(Stream.t, [atom], EctoCSV.Schema) :: Stream.t
  defp create_key_value_tuples(stream, headers, schema) do
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

  @spec load_row(Stream.t, EctoCSV.Schema) :: Stream.t
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

  @spec type(EctoCSV.Schema, atom) :: atom
  defp type(schema, field) do
    schema.__schema__(:type, field) || :string
  end

  @spec separator(EctoCSV.Schema) :: String
  defp separator(schema) do
    schema.__csv__ :separator
  end

  @spec delimiter(EctoCSV.Schema) :: String
  defp delimiter(schema) do
    schema.__csv__ :delimiter
  end

  @spec to_atom(any) :: [atom] | atom
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
