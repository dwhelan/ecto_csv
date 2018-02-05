defmodule EctoCSV.Adapters.Nimble do
  require NimbleCSV.RFC4180
  NimbleCSV.define(EctoCSV.Adapters.Nimble.Custom, separator: ",", escape: "\"")
  alias EctoCSV.Adapters.Nimble.Custom

  def read(stream, schema) do
    create_custom_nimble(schema).parse_stream(stream, headers: false)
  end

  def write(stream, schema) do
    create_custom_nimble(schema).dump_to_stream(stream)
  end

  defp create_custom_nimble(schema) do
    Code.compiler_options(ignore_module_conflict: true)
    NimbleCSV.define(Custom, options(schema))
    Code.compiler_options(ignore_module_conflict: false)
    Custom
  end

  defp options(schema) do
    [
      separator: schema.__csv__(:separator)
    ]
  end
end
