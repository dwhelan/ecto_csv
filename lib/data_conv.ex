defmodule MortgageRetention.Recipient do

  defmacro member_id do
  end
end

defmodule MortgageRetention.Process do
end

defmodule DataConv do

  require Logger
  require CSV

  def process(input_path, output_path) do
    Logger.info "Processing '#{input_path}' to '#{output_path}'"

    stream!(input_path)
    |> decode
    |> process_line
  end

  defp stream!(file) do
    File.stream!(file)
  end

  defp decode(line) do
    CSV.decode(line, headers: true, separator: ?|)
  end

  defp process_line(line) do
    IO.inspect Enum.take(line, 1)
  end
end
