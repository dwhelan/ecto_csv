
defmodule Inbox.CSV do
  defmodule Parser do
    @callback parse(Stream.t) :: Stream.t
  end
  
  defmodule Formatter do
    @callback format(stream :: any()) :: any()
  end
end

defmodule Inbox.CSV.RFC4180 do
  @behaviour Inbox.CSV.Parser
  @behaviour Inbox.CSV.Formatter

  alias NimbleCSV.RFC4180, as: CSV

  def parse(stream) do
    CSV.parse_stream(stream, headers: false)
  end

  def format(stream) do
    CSV.dump_to_stream(stream)
  end
end

defmodule DataConv do
  require Logger

  def process(input_path, output_path) do
    Logger.info "Processing '#{input_path}' to '#{output_path}'"

    process_stream(File.stream!(input_path), File.stream!(output_path))
  end

  def process(input) when is_list(input) do
    output = []
    process_stream(input, output)
    output
  end

  def process_stream(input_stream, output_stream) do
    input_stream
    |> parse
    |> Stream.map(fn row -> map_input(row) end )
    |> Stream.map(fn map -> transform(map) end )
    |> Stream.map(fn row -> map_output(row) end )
    |> format
    |> output(output_stream)
  end

  defp parse(stream) do
    Inbox.CSV.RFC4180.parse(stream)
  end

  defp map_input(row) do
    row
  end

  defp transform(map) do
    map
  end

  defp map_output(stream) do
    stream
  end

  def format(stream) do
    Inbox.CSV.RFC4180.format(stream)
  end

  def output(stream, output_stream) do
    Enum.into(stream, output_stream)
  end
end

