defmodule DataConv do
  alias EctoCSV.Loader
  alias EctoCSV.Dumper

  def process(path, destination, schema) when is_binary(path) do
    Loader.load(path, schema) |> Dumper.dump(destination)
  end

  def process(stream, schema) do
    Loader.load(stream, schema) |> Dumper.dump
  end
end

