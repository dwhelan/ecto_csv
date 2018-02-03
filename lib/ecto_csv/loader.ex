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
    stream
    |> extract_headers(schema)
    |> decode
    |> to_struct_stream
  end

  defp extract_headers(stream, schema) do
    if schema.__csv__(:file_has_header?) do
      {stream |> remove_header, schema, file_headers(stream, schema)}
    else
      {stream, schema, schema.__csv__(:headers)}
    end
  end

  defp file_headers(stream, schema) do
    stream
    |> decode(schema)
    |> take_header
    |> ensure_valid_header
    |> to_atom
  end

  defp take_header(stream) do
    stream |> Enum.take(1) |> List.first
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

  defp decode(stream, schema) do
    CSV.decode(stream, schema)
  end

  defp decode({stream, schema, headers}) do
    {CSV.decode(stream, schema), schema, headers}
  end

  defp to_struct_stream({stream, schema, headers}) do
    stream
    |> Stream.map(&validate_row({&1, schema, headers}))
    |> Stream.map(&convert_to_tuples(&1))
    |> Stream.map(&load_row(&1, schema, headers))
  end

  defp validate_row({values, schema, headers}) do
    if schema.__csv__(:file_has_header?) do
      if length(values) != length(headers) do
        raise LoadError.exception(line: 2, message: "extra fields found")
      end
      {values, schema, headers}
    else
      if schema.__csv__(:extra_columns) == :retain do
        {values, schema, create_headers_with_extras(headers, values)}
      else
        {values, schema, headers}
      end
    end
  end

  defp create_headers_with_extras(headers, values) do
    extra_headers = for x <- length(headers)..length(values), do: Enum.join(["Field", to_string(x+1)])
    headers ++ to_atom(extra_headers)
end

  defp convert_to_tuples({values, schema, headers}) do
    Enum.zip(headers, values)
  end

  defp load_row(tuples, schema, headers) do
    tuples |> Enum.reduce(struct(schema), &load_value(&1, &2, schema))
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

  defp to_atom(list) when is_list(list) do
    list |> Enum.map(&to_atom(&1))
  end

  defp to_atom(string) do
    try do
      String.to_existing_atom(string)
    rescue ArgumentError -> 
      String.to_atom(string)
    end
  end
end
