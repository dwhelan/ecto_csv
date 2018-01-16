defmodule CSV.Schema do
  alias Ecto.Type

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      use Ecto.Schema

      Module.register_attribute(__MODULE__, :csv_headers, accumulate: false)
      Module.put_attribute(__MODULE__, :csv_headers, true)
    end
  end

  defmacro csv([do: block]) do
    quote do
      try do
        # import CSV.Schema
        unquote(block)
      after
        :ok
      end
      Module.eval_quoted __ENV__, CSV.Schema.__csv__(@csv_headers)
    end
  end

  defmacro headers(headers) do
    quote do
      CSV.Schema.__headers__(__MODULE__, unquote(headers))
    end
  end

  def __headers__(mod, headers) do
    Module.put_attribute(mod, :csv_headers, headers)
  end

  def __csv__(headers) do
    quote do
      def __csv__(:headers),           do: unquote(headers)
      def __csv__(:file_has_headers?), do: unquote(headers != false)
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
