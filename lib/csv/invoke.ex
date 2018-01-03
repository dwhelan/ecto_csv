defmodule CSV.Invoke do
  import Kernel, except: [apply: 3]

  @doc """
  Invokes the given `fun` with the list of arguments `args`.

  Inlined by the compiler.

  ## Examples

      iex> apply(fn x -> x * 2 end, [2])
      4

  """
  @spec apply(atom | binary, [any]) :: any
  def apply(fun, args) when is_atom(fun) or is_binary(fun) do
    apply_with_inferred_module(fun, args)
  end

  @spec apply(fun, [any]) :: any
  def apply(fun, args) do
    Kernel.apply(fun, args)
  end

  @spec apply(list, fun, [any]) :: any
  def apply(modules, fun, args) when is_list(modules) do
    {module, function} = extract_module_and_function(fun)
    apply(module || find_module(function, modules), function, args)
  end

  def apply(module, fun, args) do
    Kernel.apply(alias_for(module), atom(fun), args)
  end

  defp apply_with_inferred_module(fun, args) do
    {module, function} = extract_module_and_function(fun)
    apply(module || Kernel, function, args)
  end

  defp extract_module_and_function(fun) do
    case Regex.named_captures(~r/(?<module>^.*)\.(?<function>[^\.]*)$/, to_string(fun)) do
      m when is_map(m) -> { m["module"], m["function"]}
      nil              -> { nil, fun }
    end
  end

  defp atom(atom) when is_atom(atom) do
    atom
  end

  defp atom(string) do
    try do String.to_existing_atom(string)
    rescue _ -> String.to_atom(string)
    end
  end

  defp alias_for(module) do
    try do Module.safe_concat([module])
    rescue _ -> Module.concat([module])
    end
  end

  defp find_module(f_name, modules) do
    Enum.find(List.wrap(modules), fn module -> :erlang.function_exported(alias_for(module), atom(f_name), 1) end) 
  end
end
