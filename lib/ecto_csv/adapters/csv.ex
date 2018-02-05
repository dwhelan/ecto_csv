defmodule EctoCSV.Adapters.CSV do
  require CSV

  def read(stream, options) do
    Elixir.CSV.decode(stream, options2(options))
    |> Stream.map(fn {:ok, list} -> list end)
  end

  def write(stream, schema) do
    Elixir.CSV.encode(stream, options(schema))
  end

  defp options2(options) do
    [
      separator: hd(String.to_charlist(options[:separator])),
      delimiter: options[:delimiter]
    ]
  end

  defp options(schema) do
    [
      separator: hd(String.to_charlist(schema.__csv__(:separator))),
      delimiter: schema.__csv__(:delimiter)
    ]
  end
end
