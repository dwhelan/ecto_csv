defmodule EctoCSV.Adapters.CSV do
  require CSV

  @default_options separator: ",", delimiter: "\r\n"

  @moduledoc """
  Read and writes data streams using the CSV package.
  """

  @doc """
  Takes an input stream of strings and returns a stream of lists of values.
  """
  @spec read(Stream.t, Keyword.t) :: Stream.t
  def read(stream, options \\ []) do
    Elixir.CSV.decode!(stream, adaptor(options))
  end

  @doc """
  Takes an output stream of list of values and returns a stream of strings.
  """
  @spec write(Stream.t, Keyword.t) :: Stream.t
  def write(stream, options \\ []) do
    Elixir.CSV.encode(stream, adaptor(options))
  end

  @spec adaptor(Keyword.t) :: Keyword.t
  defp adaptor(options) do
    @default_options
    |> Keyword.merge(options)
    |> Keyword.update!(:separator, &first_char(&1))
  end

  @spec adaptor(String.t) :: Char.t
  defp first_char(string) do
    string |> String.to_charlist |> List.first
  end
end
