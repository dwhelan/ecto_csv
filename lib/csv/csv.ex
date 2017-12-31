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

  defmodule Column do
    defstruct columns: [], format: &Cell.identity/1, parse: &Cell.identity/1

    def identity(value) do
      value
    end
  end

end
