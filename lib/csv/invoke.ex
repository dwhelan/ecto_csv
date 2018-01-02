defmodule CSV.Invoke do

  def call(function, value, modules \\ [])

  def call(f, value, _modules) when is_function(f) do
    f.(value)
  end

  def call({module, function}, args, _modules) do
    do_call(module, function, args)
  end

  def call(function, args, modules) do
    parts = Regex.split(~r/\./, to_string(function))

    if module_specified?(parts) do
      do_call(module_from(parts), function_from(parts), args)
    else
      do_call(find_module(function, modules), function, args)
    end
  end

  defp do_call(module, function, args) do
    Kernel.apply(to_module_atom(module), to_atom(function), List.wrap(args))
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

  defp find_module(function, modules) do
    Enum.find(List.wrap(modules), fn module -> :erlang.function_exported(module, function, 1) end) 
  end

  defp to_atom(value) do
    String.to_atom(to_string(value))
  end

  defp to_module_atom(module) do
    Module.concat([module])
  end
end
