defmodule EctoCSV.Adapters.CSV do
  require CSV

  def decode(stream, schema) do
    stream
    |> Elixir.CSV.decode
    |> Stream.map(fn {:ok, list} -> list end)
  end
end
