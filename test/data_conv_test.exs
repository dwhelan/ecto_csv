defmodule DataConvTest do
  use ExUnit.Case
  require CSV.Cell, as: Cell
  require CSV.Row, as: Row

  describe "Cell" do
    test "update" do
      cell = %Cell{value: 1}
      # IO.inspect __ENV__
      assert Cell.update(cell, 2) == %Cell{value: 2}
    end
  end

  describe "Row" do
    test "map" do
      values = ["a", "b"]
      assert Row.map(values, nil) === ["a", "b"]
    end
  end
end
