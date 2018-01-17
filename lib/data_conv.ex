
defmodule Inbox.EctoCSV do
  defmodule Parser do
    @callback parse(Stream.t) :: Stream.t
  end
  
  defmodule Formatter do
    @callback format(stream :: any()) :: any()
  end
end

defmodule Inbox.EctoCSV.RFC4180 do
  @behaviour Inbox.EctoCSV.Parser
  @behaviour Inbox.EctoCSV.Formatter

  alias NimbleCSV.RFC4180, as: EctoCSV

  def parse(stream) do
    EctoCSV.parse_stream(stream, headers: false)
  end

  def format(stream) do
    EctoCSV.dump_to_stream(stream)
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
    Inbox.EctoCSV.RFC4180.parse(stream)
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
    Inbox.EctoCSV.RFC4180.format(stream)
  end

  def output(stream, output_stream) do
    Enum.into(stream, output_stream)
  end
end

