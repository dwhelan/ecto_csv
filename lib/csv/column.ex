defmodule CSV.Column do

  def input({_, transform: transform}, value) do
    {:ok, [transform.(value), value]}
  end

  def input(_, value) do
    {:ok, [value]}
  end
end
