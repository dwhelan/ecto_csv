defmodule CSV.Loader do
  alias NimbleCSV.RFC4180, as: Parser

  def load(path, schema) when is_binary(path) do
    load(File.stream!(path), schema)
  end

  def load(stream, schema) do
    headers = headers(stream)

    stream
    |> remove_header
    |> to_values
    |> to_struct(schema, headers)
  end

  defp headers(stream) do
    hd(Enum.take(stream |> to_values, 1))
  end

  defp remove_header(stream) do
    Stream.transform(stream, true, fn struct, is_header -> 
      case is_header do
        true  -> { [], false }
        false -> { [struct], false }
      end
    end )
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

  defp set_struct_value({name, value}, struct, schema) do
    field = String.to_atom(name)
    value = CSV.Schema.cast(schema, field, value)
    struct(struct, Keyword.new([{field, value}]))
  end
end
