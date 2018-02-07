defmodule EctoCSV.Adapters.Nimble do
  NimbleCSV.define(EctoCSV.Adapters.Nimble.CommaSeparator, separator: ",",  escape: "\"")
  NimbleCSV.define(EctoCSV.Adapters.Nimble.PipeSeparator,  separator: "|",  escape: "\"")
  NimbleCSV.define(EctoCSV.Adapters.Nimble.TabSeparator,   separator: "\t", escape: "\"")

  alias EctoCSV.Adapters.Nimble.CommaSeparator 
  alias EctoCSV.Adapters.Nimble.PipeSeparator
  alias EctoCSV.Adapters.Nimble.TabSeparator

  def read(stream, options) do
    nimble_for(options).parse_stream(stream, headers: false)
  end

  def write(stream, options) do
    nimble_for(options).dump_to_stream(stream)
  end

  defp nimble_for(options) do
    case options[:separator] do
      ","  -> CommaSeparator
      "|"  -> PipeSeparator
      "\t" -> TabSeparator
    end
  end
end
