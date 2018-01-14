defmodule CSV.Loader do

  def load(path, schema) when is_binary(path) do
    load(File.stream!(path), schema)
  end

  def load(stream, schema) do
    stream = stream |> CSV.Parser.parse
    
    headers = hd(Enum.take(stream, 1))

    stream
    |> Stream.with_index
    |> Stream.filter(fn {_, index} -> index >= 1 end)
    |> Stream.map(fn {line, _} -> load_row(line, schema, headers) end)
  end

  defp load_row(row, schema, headers) do
    Enum.zip(headers, row)
    |> Enum.reduce(struct(schema), fn(name_string, record) -> update(name_string, record, schema) end)
  end

  defp update({name, string}, record, schema) do
    field = String.to_atom(name)
    value =  CSV.Schema.cast(schema, field, string)
    struct(record, Keyword.new([{field, value}]))
  end
end
