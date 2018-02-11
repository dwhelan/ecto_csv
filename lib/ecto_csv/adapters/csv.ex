defmodule EctoCSV.Adapters.CSV do
  require CSV

  @default_options separator: ",", delimiter: "\r\n"

  @moduledoc """
  Read and writes data streams according to the options provided. These
  options may include custom separators and delimiters.
  """

  @doc """
  Reads an input stream of strings and maps each string to a list of values.
  Input strings are split using the separator specified in options defaulting to a comma separator.
  Returns a stream of lists of strings.
  """
  @spec read(Stream.t, Keyword.t) :: Stream.t
  def read(stream, options \\ []) do
    Elixir.CSV.decode!(stream, adaptor(options))
  end

  @doc """
  Assembles the row of data and separates them using the 'separator' option 
  provided by the schema. Returns a stream containing the formatted data.
  """
  @spec write(Stream.t, Keyword.t) :: Stream.t
  def write(stream, options \\ []) do
    Elixir.CSV.encode(stream, adaptor(options))
  end

  @spec adaptor(Keyword.t) :: Keyword.t
  defp adaptor(options) do
    options = Keyword.merge(@default_options, options )
    Keyword.update!(options, :separator, &String.to_charlist(&1) |> List.first)
  end
end
