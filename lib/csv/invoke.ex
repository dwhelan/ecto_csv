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
    :erlang.apply(fun, args)
  end

  def apply(modules, f_name, args) when is_list(modules) do
    if length(modules) == 1 do
      apply(hd(modules), f_name, args)
    else
      parts = Regex.split(~r/\./, to_string(f_name))

      if module_specified?(parts) do
        do_apply(module_from(parts), function_from(parts), args)
      else
        do_apply(find_module(f_name, modules), f_name, args)
      end
    end
  end

  def apply(module, fun, args) do
    Kernel.apply(alias_for(module), atom(fun), args)
  end

  defp apply_with_inferred_module(fun, args) do
    {module, function} = extract_module_and_function(fun)
    :erlang.apply(module, function, args)
  end

  defp extract_module_and_function(fun) do
    case Regex.named_captures(~r/(?<module>^.*)\.(?<function>[^\.]*)$/, to_string(fun)) do
      m when is_map(m) -> { alias_for(m["module"]), atom(m["function"])}
      nil              -> { Kernel, atom(fun) }
    end
  end

  defp atom(atom) when is_atom(atom) do
    atom
  end

  defp atom(string) do
    try do
      String.to_existing_atom(string)
    rescue
      _ -> String.to_atom(string)
    end
  end


  defp alias_for(module) do
    try do
      Module.safe_concat([module])
    rescue
      _ -> Module.concat([module])
    end
  end

  ################



  defp do_apply(module, f_name, args) do
    Kernel.apply(to_module_atom(module), to_atom(f_name), args)
  end

  defp module_specified?(function_parts) do
    length(function_parts) > 1
  end

  defp module_from(parts) do
    Module.concat(List.delete_at(parts, -1))
  end

  defp function_from(parts) do
    List.last(parts)
  end

  defp find_module(f_name, modules) do
    Enum.find(List.wrap(modules), fn module -> :erlang.function_exported(module, f_name, 1) end) 
  end

  defp to_atom(value) do
    String.to_atom(to_string(value))
  end

  defp to_module_atom(module) do
    Module.concat([module])
  end
end
