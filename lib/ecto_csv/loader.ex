defmodule EctoCSV.Loader do
  alias NimbleCSV.RFC4180, as: Parser

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
    _headers = stream_headers(stream)
    headers = EctoCSV.headers(schema)

    stream = if EctoCSV.file_has_header?(schema), do: stream |> remove_header, else: stream
    
    stream
    |> to_values
    |> to_struct(schema, headers)
  end

  defp stream_headers(stream) do
    hd(Enum.take(stream |> to_values, 1))
  end

  defp remove_header(stream) do
    Stream.transform(stream, 0, fn struct, index -> 
      case index do
        0 -> {[],       :ignore_header}
        _ -> {[struct], :process_stream}
      end
    end)
  end

  def to_values(stream) do
    Parser.parse_stream(stream, headers: false)
  end

  defp to_struct(stream, schema, headers) do
    Stream.map(stream, &create_struct(&1, schema, headers))
  end

  defp create_struct(values, schema, headers) do
    Enum.zip(headers, values) |> Enum.reduce(struct(schema), &set_struct_value(&1, &2, schema))
  end

  defp set_struct_value({field, value}, struct, schema) do
    {:ok, value} = EctoCSV.cast(schema, field, value)
    struct(struct, Keyword.new([{field, value}]))
  end
end
