defmodule CSV.Column do
  def input({_name, options}, value) do
    {:ok, options, value}
    |> parse
    |> transform
    |> result
  end

  defp parse({:ok, options, string}) do
    if type = options[:type] do
      apply_parse(type, delete(options, :type), string)
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

  defp apply_parse(type, options, string) when type in [String, "String"],
     do: {:ok, options, string}

  defp apply_parse(type, options, string) when type in [Integer, "Integer"] do
    case Integer.parse(string) do
      {integer, _} -> {:ok,    options, integer}
      :error       -> {:error, options, ["'#{string}' is not an Integer"]}
    end
  end

  defp apply_parse(type, options, _value),
    do: {:error, options, ["unknown type '#{type}'"]}

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
