defmodule EctoCSV.Adapters.Nimble do
  require NimbleCSV.RFC4180

  def load(stream) do
    NimbleCSV.RFC4180.parse_stream(stream, headers: false)
  end
end
