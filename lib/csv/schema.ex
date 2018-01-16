defmodule CSV.Schema do
  alias Ecto.Type

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      use Ecto.Schema
    end
  end

  def cast(schema, field, string) do
    case type = type(schema, field) do
      nil -> string
      _   -> {:ok, value} = Type.cast(type, string)
             value
    end
  end

  def dump(schema, field, value) do
    case type = type(schema, field) do
      nil -> value
      _   -> {:ok, value} = Type.dump(type, value)
             value
    end
  end

  def type(schema, field) do
    schema.__schema__(:type, field)
  end
end
