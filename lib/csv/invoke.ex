defmodule CSV.Invoke do
  import Kernel, except: [apply: 2, apply: 3]

  @doc """
  Invokes the given `fun` by name with the list of arguments `args`.
  `fun` can include a module name and if missing will default to `Kernel`.

  ## Examples

      iex> Invoke.apply(:node, [])
      :nonode@nohost
      iex> Invoke.apply("round", [3.1415])
      3
      iex> Invoke.apply("Kernel.div", [6,3])
      2

  """
  @spec apply(atom | binary, [any]) :: any
  def apply(fun, args) when is_atom(fun) or is_binary(fun) do
    {module, function} = module_and_function(fun)
    apply(module || Kernel, function, args)
  end

  @doc """
  Invokes the given `fun` with the list of arguments `args`.

  ## Examples

      iex> Invoke.apply(fn x -> x * 2 end, [2])
      4

  """
  @spec apply(fun, [any]) :: any
  def apply(fun, args) do
    Kernel.apply(fun, args)
  end

  @doc """
  Finds the first function in modules `modules` with the name `fun` and correct arity and invokes it
  with the list of arguments `args`.

  If the module is extracted from `fun` then it will be used and `modules` will not be searched.
  
  ## Examples

      iex> Invoke.apply([IO, Kernel], :div, [6,3])
      2
      iex> Invoke.apply([], "Kernel.div", [6,3])
      2

  """
  @spec apply([module | atom | binary], atom | binary, [any]) :: any
  def apply(modules, fun, args) when is_list(modules) do
    {module, function} = module_and_function(fun)
    apply(module || find_module(modules, function, length(args)), function, args)
  end

  @doc """
  Invokes the function in module `module` with the name `fun` with the list of arguments `args`.
  
  ## Examples

      iex> Invoke.apply(Kernel, :div, [6,3])
      2

  """
  @spec apply(module | atom | binary, atom | binary, [any]) :: any
  def apply(module, fun, args) do
    Kernel.apply(alias_for(module), atom(fun), args)
  end

  defp module_and_function(fun) do
    case Regex.named_captures(~r/(?<module>^.*)\.(?<function>[^\.]*)$/, to_string(fun)) do
      m when is_map(m) -> {m["module"], m["function"]}
      nil              -> {nil, fun}
    end
  end

  defp atom(atom) when is_atom(atom) do
    atom
  end

  defp atom(binary) do
    try do String.to_existing_atom(binary)
    rescue _ -> String.to_atom(binary)
    end
  end

  defp alias_for(module) do
    try do Module.safe_concat([module])
    rescue _ -> Module.concat([module])
    end
  end

  defp find_module(modules, fun, arg_count) do
    Enum.find(modules, &:erlang.function_exported(alias_for(&1), atom(fun), arg_count)) 
  end
end
