defmodule CSV.Parser do

  alias NimbleCSV.RFC4180, as: CSV

  def parse(stream) do
    CSV.parse_stream(stream, headers: false)
  end

  def format(stream) do
    CSV.dump_to_stream(stream)
  end
end