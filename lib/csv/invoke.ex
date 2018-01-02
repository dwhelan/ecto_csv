defmodule CSV.Invoke do

  def apply(_modules, f, value) when is_function(f) do
    f.(value)
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
    Kernel.apply(to_module_atom(module), to_atom(f_name), List.wrap(args))
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
