defmodule CSV.Loader do
  alias NimbleCSV.RFC4180, as: Parser

  def load(path, mod) when is_binary(path) do
    load(File.stream!(path), mod)
  end

  def load(stream, mod) do
    _headers = stream_headers(stream)
    headers = CSV.headers(mod)

    stream = if CSV.has_headers?(mod), do: stream |> remove_header, else: stream
    
    stream
    |> to_values
    |> to_struct(mod, headers)
  end

  defp stream_headers(stream) do
    hd(Enum.take(stream |> to_values, 1))
  end

  defp remove_header(stream) do
    Stream.transform(stream, true, fn struct, is_header -> 
      case is_header do
        true  -> { [], false }
        false -> { [struct], false }
      end
    end)
  end

  def to_values(stream) do
    Parser.parse_stream(stream, headers: false)
  end

  defp to_struct(stream, mod, headers) do
    Stream.map(stream, &create_struct(&1, mod, headers))
  end

  defp create_struct(values, mod, headers) do
    Enum.zip(headers, values) |> Enum.reduce(struct(mod), &set_struct_value(&1, &2, mod))
  end

  defp set_struct_value({name, value}, struct, mod) do
    field = String.to_atom(name)
    value = CSV.Schema.cast(mod, field, value)
    struct(struct, Keyword.new([{field, value}]))
  end
end
