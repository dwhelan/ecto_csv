defmodule EctoCSV.Adapters.Nimble do
  NimbleCSV.define(EctoCSV.Adapters.Nimble.CommaSeparator, separator: ",",  escape: "\"")
  NimbleCSV.define(EctoCSV.Adapters.Nimble.PipeSeparator,  separator: "|",  escape: "\"")
  NimbleCSV.define(EctoCSV.Adapters.Nimble.TabSeparator,   separator: "\t", escape: "\"")

  alias EctoCSV.Adapters.Nimble.CommaSeparator 
  alias EctoCSV.Adapters.Nimble.PipeSeparator
  alias EctoCSV.Adapters.Nimble.TabSeparator

  def read(stream, schema) do
    nimble_for(schema).parse_stream(stream, headers: false)
  end

  def write(stream, schema) do
    nimble_for(schema).dump_to_stream(stream)
  end

  defp nimble_for(schema) do
    case options(schema)[:separator] do
      ","  -> CommaSeparator
      "|"  -> PipeSeparator
      "\t" -> TabSeparator
      _   -> custom_for(schema)
    end
  end

  defp custom_for(schema) do
    NimbleCSV.define(EctoCSV.Adapters.Nimble.Custom, options(schema))
    EctoCSV.Adapters.Nimble.Custom
  end

  defp options(schema) do
    [
      separator: schema.__csv__(:separator)
    ]
  end
end
