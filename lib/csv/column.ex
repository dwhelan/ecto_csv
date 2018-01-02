defmodule CSV.Column do

  defmodule Invoke do

    def call(function, value, modules \\ [])

    def call(f, value, _modules) when is_function(f) do
      f.(value)
    end

    def call({module, function}, value, _modules) do
      do_call(module, function, value)
    end

    def call(function, value, modules) when is_binary(function) or is_atom(function) do
      function_parts = Regex.split(~r/\./, to_string(function))

      if length(function_parts) === 1 do
        module = find_module(function, modules)
        do_call(module, function, value)
      else
        module = Module.concat(List.delete_at(function_parts, -1))
        function = List.last(function_parts)
        do_call(module, function, value)
      end
    end

    defp do_call(module, function, value) do
      Kernel.apply(to_module_atom(module), to_atom(function), [value])
    end

    defp find_module(function, modules) do
      Enum.find(List.wrap(modules), fn module -> :erlang.function_exported(module, function, 1) end) 
    end

    defp to_atom(val) do
      String.to_atom(to_string(val))
    end

    defp to_module_atom(module) do
      Module.concat([module])
    end
  end

  def input2({_name, transforms}, value, options \\ %{}) do
    transform2(value, List.wrap(transforms), options)
  end

  defp transform2(value, transforms, options) do
    Enum.reduce(transforms, {:ok, value}, fn(transform, value) -> apply_transform2(transform, value, options) end)
  end

  defp apply_transform2(_transform, {:error, errors}, _options) do
    {:error, errors}
  end

  defp apply_transform2(transform, {:ok, value}, options) do
    try do
      {:ok, Invoke.call(transform, value, options[:modules] || []) }
    rescue
      # e in FunctionClauseError    -> {:error, [FunctionClauseError.message(e)]}
      e in UndefinedFunctionError -> {:error, [UndefinedFunctionError.message(e)]}
    end
  end

  def input({_name, options}, value) do
    {:ok, options, value}
    |> parse
    |> transform
    |> result
  end

  defp parse({:ok, options, string}) do
    if type = options[:type] do
      {status, result } =  apply_parse(type, string)
      {status, delete(options, :type), result}
    else
      {:ok, options, string}
    end
  end

  defp transform({:ok, options, value}) do
    if f = options[:transform] do
      apply_transform(f, delete_first(options, :transform), value) |> transform
    else
      {:ok, options, value}
    end
  end

  defp transform({:error, options, errors}) do
    {:error, options, errors}
  end

  defp result{status, _options, value} do
    {status, value}
  end

  defp apply_parse(type, string) do
    cond do
      is_a?(String,  type) -> {:ok,    string}
      is_a?(Integer, type) -> parse_integer(string)
      true                 -> {:error, ["unknown type '#{type}'"]}
    end
  end

  # @parsers %{Integer => &CSV.Column.parse_integer/1}

  defp parse_integer(string) do
    case Integer.parse(string) do
      {integer, _} -> {:ok,    integer}
      :error       -> {:error, ["'#{string}' is not an Integer"]}
    end
  end

  defp is_a?(module, type) do
    "#{module}" in ["#{type}", "Elixir.#{type}"]
  end

  defp apply_transform(f, options, value) do
    try do
      if is_function(f) do
        {:ok, options, f.(value)}
      else
        f_atom = if is_atom(f), do: f, else: String.to_atom(f)
        {:ok, options, Kernel.apply(String, f_atom, [value])}
      end
    rescue
      e in FunctionClauseError    -> {:error, options, [FunctionClauseError.message(e)]}
      e in UndefinedFunctionError -> {:error, options, [UndefinedFunctionError.message(e)]}
    end
  end

  defp delete(options, key) do
    Keyword.delete(options, key)
  end

  defp delete_first(options, key) do
    Keyword.delete_first(options, key)
  end
end
