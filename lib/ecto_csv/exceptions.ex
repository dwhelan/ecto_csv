defmodule EctoCSV.LoadError do
  @moduledoc """
  Raised at runtime when an error is encounted in a file being loaded.
  """

  defexception [:line, :message]

  def exception(options) do
    line    = options |> Keyword.fetch!(:line)
    message = options |> Keyword.fetch!(:message)

    %__MODULE__{
      line: line,
      message: message <> " on line " <> Integer.to_string(line)
    }
  end
end
