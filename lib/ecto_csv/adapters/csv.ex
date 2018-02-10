defmodule EctoCSV.Adapters.CSV do
  require CSV

  @moduledoc """
  Parses and formats data streams according to the options provided. These
  options may include custom separators and delimiters.
  """

  @doc """
  Parses row of data by using the 'separator' option as a splitter. Returns
  a stream containing the parsed data.
  """
  @spec read(Stream.t, Keyword.t) :: Stream.t
  def read(stream, options) do
    Elixir.CSV.decode!(stream, adaptor(options))
  end

  @doc """
  Assembles the row of data and separates them using the 'separator' option 
  provided by the schema. Returns a stream containing the formatted data.
  """
  @spec write(Stream.t, Keyword.t) :: Stream.t
  def write(stream, options) do
    Elixir.CSV.encode(stream, adaptor(options))
  end

  @spec adaptor(Keyword.t) :: Keyword.t
  defp adaptor(options) do
    Keyword.update!(options, :separator, &String.to_charlist(&1) |> List.first)
  end
end
