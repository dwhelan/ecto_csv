defmodule DataConv do
  alias EctoCSV.Loader
  alias EctoCSV.Dumper

  def process(input, destination, schema) when is_binary(input) do
    Loader.load(input, schema)
    |> Dumper.dump(destination)
  end

  def process(input, schema) do
    Loader.load(input, schema)
    |> Dumper.dump
  end
end

