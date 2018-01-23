defmodule EctoCSV.Adapters.Nimble do
  require NimbleCSV.RFC4180

  def decode(stream, _schema) do
    NimbleCSV.RFC4180.parse_stream(stream, headers: false)
  end
end
