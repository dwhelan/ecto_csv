defmodule CSV.Column do

#  def input(col = {_, type: Integer}, value) do
#    input(col, Keyword.delete())
#    {:ok, [transform.(value), value]}
#  end

  def input({name , options}, value) do
    transform = options[:transform]
    if transform do
      input({name, Keyword.delete(options, :transform)}, transform.(value))
    else
      {:ok, value}
    end
  end
#
#  def input(_, value) do
#    {:ok, [value]}
#  end
end
