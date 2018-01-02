defmodule CSV.Invoke do

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

  defp to_atom(value) do
    String.to_atom(to_string(value))
  end

  defp to_module_atom(module) do
    Module.concat([module])
  end
end
