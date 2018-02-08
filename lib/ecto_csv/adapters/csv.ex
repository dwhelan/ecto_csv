defmodule EctoCSV.Adapters.CSV do
  require CSV

  @spec read(Stream.t, Keyword.t) :: Stream.t
  def read(stream, options) do
    Elixir.CSV.decode(stream, adaptor(options))
    |> Stream.map(fn {:ok, list} -> list end)
  end

  @spec write(Stream.t, Keyword.t) :: Stream.t
  def write(stream, options) do
    Elixir.CSV.encode(stream, adaptor(options))
  end

  @spec adaptor(Keyword.t) :: Keyword.t
  defp adaptor(options) do
    Keyword.update!(options, :separator, &String.to_charlist(&1) |> List.first)
  end
end
