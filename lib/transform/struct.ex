defmodule Transform.Struct do
  def cast(map, mod) do
    Map.keys(map)
    |> remove_meta_keys
    |> copy_values(map, mod)
  end

  @does_not_start_with__ ~r/^(?!__).+/
  defp remove_meta_keys(keys) do
    Enum.filter(keys, &Regex.match?(@does_not_start_with__, Atom.to_string(&1))) 
  end

  defp copy_values(keys, map, mod) when is_atom(mod) do
    copy_values(keys, map, struct(mod))
  end

  defp copy_values(keys, map, other_map) do
    Enum.reduce(keys, other_map, &copy_value(&1, &2, map))
  end

  defp copy_value(key, other_map, map) do
    Map.put(other_map, key, Map.get(map, key))
  end
end
