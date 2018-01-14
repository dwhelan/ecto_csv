defmodule CSV.Schema do
  alias Ecto.Type

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      use Ecto.Schema

      Module.register_attribute(__MODULE__, :csv_columns, accumulate: true)
    end
  end

  defmacro columns(do: block) do
    quote do
      Ecto.Schema.schema("csv") do
        unquote(block)
      end

      columns = @csv_columns |> Enum.reverse

      Module.eval_quoted __ENV__, CSV.Schema.__csv__(columns)
    end
  end

  defmacro column(name, type \\ :string, opts \\ []) do
    quote do
      Ecto.Schema.field unquote(atom(name)), unquote(type), unquote(opts)
      CSV.Schema.__columns__(__MODULE__, unquote(name))
    end
  end

  def __columns__(mod, name) do
    Module.put_attribute(mod, :csv_columns, name)
  end

  def __csv__(column_names) do
    quote do
      def __csv__(:columns), do: unquote(column_names)
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

  defp atom(string) when is_binary(string) do
    String.to_atom(string)
  end

  defp atom(atom) do
    atom
  end

  # Prevent direct access to "schema" & "field" macros so we
  # force columns to be defined via "columns" && ""column" macros.
  defmacro schema(_, do: _) do end
  defmacro field(_) do end
  defmacro field(_, _) do end
  defmacro field(_, _, _) do end
end
