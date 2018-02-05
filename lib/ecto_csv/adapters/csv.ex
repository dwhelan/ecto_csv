defmodule EctoCSV.Adapters.CSV do
  require CSV

  def read(stream, options) do
    Elixir.CSV.decode(stream, adaptor(options))
    |> Stream.map(fn {:ok, list} -> list end)
  end

  def write(stream, options) do
    Elixir.CSV.encode(stream, adaptor(options))
  end

  defp adaptor(options) do
    Keyword.update!(options, :separator, &String.to_charlist(&1) |> List.first)
  end
end
