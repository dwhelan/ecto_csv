defmodule CSV.Schema do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      @schema %{}

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def schema do
        @schema
      end
    end
  end

  defmacro column(name, options \\ Macro.escape([])) do
    quote bind_quoted: [name: name, options: options] do
      @schema CSV.Schema.add_column(@schema, name, options)
    end
  end

  def add_column(schema, name, options \\ []) when is_map(schema) and is_binary(name) and is_list(options) do
    columns = Map.get(schema, :columns, [])
    Map.put(schema, :columns, columns ++ [{name, options}])
  end
end
