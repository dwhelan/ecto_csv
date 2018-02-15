defmodule EctoCSV.Adapters.Nimble do
  @moduledoc """
  Read and writes data streams using the `NimbleCSV` package.
  """

  alias EctoCSV.Adapters.Nimble.CommaLF 
  alias EctoCSV.Adapters.Nimble.CommaCRLF 
  alias EctoCSV.Adapters.Nimble.TabLF
  alias EctoCSV.Adapters.Nimble.TabCRLF
  alias EctoCSV.Adapters.Nimble.PipeLF
  alias EctoCSV.Adapters.Nimble.PipeCRLF

  NimbleCSV.define(CommaLF,   separator: ",",  line_separator: "\n")
  NimbleCSV.define(CommaCRLF, separator: ",",  line_separator: "\r\n")
  NimbleCSV.define(TabLF,     separator: "\t", line_separator: "\n")
  NimbleCSV.define(TabCRLF,   separator: "\t", line_separator: "\r\n")
  NimbleCSV.define(PipeLF,    separator: "|",  line_separator: "\n")
  NimbleCSV.define(PipeCRLF,  separator: "|",  line_separator: "\r\n")

  @default_options separator: ",", delimiter: "\r\n"

  @doc """
  Takes an input stream of strings and returns a stream of lists of values.
  """
  def read(stream, options \\ []) do
    csv = nimble_for(options)
    stream |> csv.parse_stream(headers: false)
  end

  @doc """
  Takes an output stream of list of values and returns a stream of strings.
  """
  def write(stream, options \\ []) do
    csv = nimble_for(options)
    stream |> csv.dump_to_stream |> Stream.map(&IO.iodata_to_binary(&1))
  end

  defp nimble_for(options) do
    options = Keyword.merge(@default_options, options)
    case {options[:separator], options[:delimiter]} do
      {",",  "\n"}   -> CommaLF
      {",",  "\r\n"} -> CommaCRLF
      {"\t", "\n"}   -> TabLF
      {"\t", "\r\n"} -> TabCRLF
      {"|",  "\n"}   -> PipeLF
      {"|",  "\r\n"} -> PipeCRLF
    end
  end
end
