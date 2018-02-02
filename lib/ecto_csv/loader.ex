defmodule EctoCSV.Loader do
  alias EctoCSV.Adapters.CSV

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
    hd(Enum.take(stream |> CSV.decode(schema), 1))
    |> Enum.map(&to_atom(&1))
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
    Stream.map(stream, &create_struct(&1, schema, headers))
  end

  defp create_struct(values, schema, headers) do
    Enum.zip(headers, values) |> Enum.reduce(struct(schema), &set_struct_value(&1, &2, schema))
  end

  defp set_struct_value({field, value}, struct, schema) do
    type = schema.__schema__(:type, field) || :string
    {:ok, value} = Ecto.Type.cast(type, value)
    Map.put(struct, field, value)
  end

  defp to_atom(string) do
    try do
      String.to_existing_atom(string)
    rescue ArgumentError -> 
      String.to_atom(string)
    end
  end
end
