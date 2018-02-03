defmodule EctoCSV.Loader do
  alias EctoCSV.Adapters.CSV
  alias EctoCSV.LoadError

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
    {stream, schema}
    |> extract_headers
    |> decode
    |> to_struct_stream
  end

  defp extract_headers({stream, schema}) do
    if schema.__csv__(:file_has_header?) do
      {stream |> remove_header, schema, file_headers(stream, schema)}
    else
      {stream, schema, schema.__csv__(:headers)}
    end
  end

  defp file_headers(stream, schema) do
    stream
    |> CSV.decode(schema)
    |> Enum.take(1)
    |> List.first
    |> ensure_valid_header
    |> Enum.map(&to_atom(&1))
  end

  defp ensure_valid_header(header) do
    if Enum.filter(header, &(String.length(&1) == 0)) |> length > 0 do
      raise LoadError.exception(line: 1, message: "blank header found")
    end
    
    duplicates = header -- Enum.uniq(header)
    if length(duplicates) > 0 do
      duplicate_string = duplicates |> Enum.uniq |> Enum.join(",")
      raise LoadError.exception(line: 1, message: "duplicate headers '#{duplicate_string}' found")
    end

    header
  end

  defp remove_header(stream) do
    Stream.transform(stream, 0, fn struct, index -> 
      case index do
        0 -> {[],       :ignore_header}
        _ -> {[struct], :process_stream}
      end
    end)
  end

  def decode({stream, schema, headers}) do
    {CSV.decode(stream, schema), schema, headers}
  end

  defp to_struct_stream({stream, schema, headers}) do
    Stream.map(stream, &load_row(&1, schema, headers))
  end

  defp load_row(values, schema, headers) do
    if length(values) != length(headers) do
      raise LoadError.exception(line: 2, message: "extra fields found")
    end

    Enum.zip(headers, values) |> Enum.reduce(struct(schema), &load_value(&1, &2, schema))
  end

  defp load_value({field, value}, struct, schema) do
    case schema.__csv__(:extra_columns) do 
      :ignore -> struct
      :error  -> raise LoadError.exception(line: 1, message: "extra column '#{field}' found")
      _       -> type = schema.__schema__(:type, field) || :string
                 {:ok, value} = Ecto.Type.cast(type, value)
                 Map.put(struct, field, value)
    end
  end

  defp to_atom(string) do
    try do
      String.to_existing_atom(string)
    rescue ArgumentError -> 
      String.to_atom(string)
    end
  end
end
