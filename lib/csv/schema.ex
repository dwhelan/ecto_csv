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

  defmacro column(name, module \\ String, options \\ Macro.escape([])) do
    quote bind_quoted: [name: name, module: module, options: options] do
      @schema CSV.Schema.add_column(@schema, name, module, options)
    end
  end

  def add_column(schema, name, module \\ String, options \\ []) when is_map(schema) and is_binary(name) and is_list(options) do
    columns = Map.get(schema, :columns, %{})
    columns = Map.put(columns, name, {module, options})
    Map.put(schema, :columns, columns)
  end
end
