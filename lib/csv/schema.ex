defmodule CSV.Schema do
  alias Ecto.Type

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      use Ecto.Schema

      Module.register_attribute(__MODULE__, :csv_header, accumulate: false)
      Module.put_attribute(__MODULE__, :csv_header, true)
    end
  end

  defmacro csv([do: block]) do
    quote do
      try do
        unquote(block)
      after
        :ok
      end
      Module.eval_quoted __ENV__, CSV.Schema.__csv__(@csv_header)
    end
  end

  defmacro header(header) do
    quote do
      CSV.Schema.__header__(__MODULE__, unquote(header))
    end
  end

  def __header__(mod, header) do
    Module.put_attribute(mod, :csv_header, header)
  end

  def __csv__(header) do
    quote do
      def __csv__(:header),           do: unquote(header)
      def __csv__(:file_has_header?), do: unquote(header != false)
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
