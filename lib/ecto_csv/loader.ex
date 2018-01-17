defmodule EctoCSV.Loader do
  alias NimbleCSV.RFC4180, as: Parser

  
  def load(path, mod) when is_binary(path) do
    load(File.stream!(path), mod)
  end

  def load(stream, mod) do
    _headers = stream_headers(stream)
    headers = EctoCSV.headers(mod)

    stream = if EctoCSV.file_has_header?(mod), do: stream |> remove_header, else: stream
    
    stream
    |> to_values
    |> to_struct(mod, headers)
  end

  defp stream_headers(stream) do
    hd(Enum.take(stream |> to_values, 1))
  end

  defp remove_header(stream) do
    Stream.transform(stream, 0, fn struct, index -> 
      case index do
        0 -> {[],       :_}
        _ -> {[struct], :_}
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

  defp set_struct_value({field, value}, struct, mod) do
    {:ok, value} = EctoCSV.cast(mod, field, value)
    struct(struct, Keyword.new([{field, value}]))
  end
end
