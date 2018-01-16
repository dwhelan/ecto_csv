defmodule Transform.Map do
  def cast(source, target \\ %{}) do
    Map.keys(source)
    |> remove_meta_keys
    |> copy_values(source, target)
  end

  @does_not_start_with__ ~r/^(?!__).+/

  defp remove_meta_keys(keys) do
    Enum.filter(keys, &Regex.match?(@does_not_start_with__, Atom.to_string(&1))) 
  end

  defp copy_values(keys, source, target) when is_atom(target) do
    copy_values(keys, source, struct(target))
  end

  defp copy_values(keys, source, target) do
    Enum.reduce(keys, target, &copy_value(&1, source, &2))
  end

  defp copy_value(key, source, target) do
    Map.put(target, key, Map.get(source, key))
  end
end
