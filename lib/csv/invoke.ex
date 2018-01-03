defmodule CSV.Invoke do
  import Kernel, except: [apply: 3]

  @doc """
  Invokes the given `fun` with the list of arguments `args`.

  Inlined by the compiler.

  ## Examples

      iex> apply(fn x -> x * 2 end, [2])
      4

  """
  @spec apply(atom, [any]) :: any
  def apply(fun, args) when is_atom(fun) do
    fun_string = to_string(fun)
    if mod_specified?(fun_string) do
      parts = Regex.split(~r/\./, fun_string)
      do_apply(module_from(parts), function_from(parts), args)
    else
      :erlang.apply(Kernel, fun, args)
    end
  end

  @spec apply(binary, [any]) :: any
  def apply(fun_string, args) when is_binary(fun_string) do
    if mod_specified?(fun_string) do
      parts = Regex.split(~r/\./, fun_string)
      do_apply(module_from(parts), function_from(parts), args)
    else
      :erlang.apply(Kernel, String.to_atom(fun_string), args)
    end
  end

  defp mod_specified?(fun) do
    String.contains?(fun, ".")
  end

  @spec apply(fun, [any]) :: any
  def apply(fun, args) do
    :erlang.apply(fun, args)
  end

  defp do_apply(fun, args) do
    fun_string = to_string(fun);
    if String.contains?(to_string(fun_string), ".") do
      parts = Regex.split(~r/\./, fun_string)
      do_apply(module_from(parts), function_from(parts), args)
    else
      :erlang.apply(Kernel, to_atom(fun), args)
    end
  end


  def apply(module, fun, args) when is_atom(module) and is_atom(fun) do
    :erlang.apply(module, fun, args)
  end

  def apply(module, f_name, args) when is_binary(module) or is_atom(module) do
    do_apply(module, f_name, args)
  end

  def apply(modules, f_name, args) do
    if length(modules) == 1 do
      do_apply(hd(modules), f_name, args)
    else
      parts = Regex.split(~r/\./, to_string(f_name))

      if module_specified?(parts) do
        do_apply(module_from(parts), function_from(parts), args)
      else
        do_apply(find_module(f_name, modules), f_name, args)
      end
    end
  end

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
