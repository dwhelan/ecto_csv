defmodule CSV do
  defmodule Cell do
    defstruct value: nil

    def update(cell, value) do
      %Cell{cell | value: value}
    end
  end

  defmodule Row do
    def map(row, _schema) do
      row
    end
  end
end
