defmodule EctoCSV.Adapters.CSV do
  require CSV

  def decode(stream, schema) do
    Elixir.CSV.decode(stream, options(schema))
    |> Stream.map(fn {:ok, list} -> list end)
  end

  def encode(stream, schema) do
    Elixir.CSV.encode(stream, options(schema))
  end

  defp options(schema) do
    [
      separator: hd(String.to_charlist(schema.__csv__(:separator))),
      delimiter: schema.__csv__(:delimiter)
    ]
  end
end
