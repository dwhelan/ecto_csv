defmodule CSV.Schema do
  alias Ecto.Type

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      use Ecto.Schema

      Module.put_attribute(__MODULE__, :csv_header, true)
    end
  end

  defmacro csv(do: block) do
    quote do
      unquote(block)
      Module.eval_quoted __ENV__, CSV.Schema.__csv__(@csv_header)
    end
  end

  def __csv__(header) do
    quote do
      def __csv__(:header),           do: unquote(header)
      def __csv__(:file_has_header?), do: unquote(header != false)
      def __csv__(:headers),          do: Module.eval_quoted __ENV__, Ecto.Schema.__schema__(:fields) |> Enum.filter(&(&1 != :id))
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

  def cast(schema, field, value) do
    {:ok, value} = type(schema, field) |> Type.cast(value)
    value
  end

  def dump(schema, field, value) do
    {:ok, value} = type(schema, field) |> Type.dump(value)
    value
  end

  defp type(schema, field) do
    schema.__schema__(:type, field) || :string
  end
end
