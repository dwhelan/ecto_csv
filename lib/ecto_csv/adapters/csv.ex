defmodule EctoCSV.Adapters.CSV do
  require CSV

  def decode(stream, schema) do
    stream
    |> Elixir.CSV.decode(options(schema))
    |> Stream.map(fn {:ok, list} -> list end)
  end

  defp options(schema) do
    [
      separator: hd(String.to_charlist(schema.__csv__(:delimiter)))
    ]
  end
end
