defmodule DataConv.CLI do
  require DataConv

  def main(args) do
    [ input, output ] = parse(args)
    DataConv.process(input, output)
  end

  defp parse([input, output | _]), do: [input, output]
  defp parse([_ | _]),             do: bad_args()
  defp parse([]),                  do: bad_args()

  defp bad_args() do
    raise "Please provide an input and an output file: data_conv <input> <output>"
  end
end
