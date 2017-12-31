defmodule CSV.Column do
  def input({_name, options}, value) do
    {:ok, value, options}
    |> parse
    |> transform
    |> result
  end

  defp parse({:ok, value, options}) do
    if type = options[:type] do
      parse(type, value, delete(options, :type))
    else
      {:ok, value, options}
    end
  end

  defp transform({:ok, value, options}) do
    if function = options[:transform] do
      apply_transform(function, value, delete_first(options, :transform))
    else
      {:ok, value, options}
    end
  end

  defp transform({status, error, options}) do
    {status, error, options}
  end

  defp result{status, value, _options} do
    {status, value}
  end

  defp parse(type, value, options) when type in [String, "String"],
     do: {:ok, value, options}

  defp parse(type, value, options) when type in [Integer, "Integer"] do
    case Integer.parse(value) do
      {integer, _} -> {:ok, integer, options}
      :error       -> {:error, ["'#{value}' is not an Integer"], options}
    end
  end

  defp parse(type, _value, options),
    do: {:error, ["unknown type '#{type}'"], options}

  defp apply_transform(function, value, options) when is_function(function) do
    try do
      {:ok, function.(value), options}
    rescue
      e in FunctionClauseError    -> {:error, [FunctionClauseError.message(e)],    options}
      e in UndefinedFunctionError -> {:error, [UndefinedFunctionError.message(e)], options}
    end
  end

  defp apply_transform(f, value, options) do
    f_atom = if is_atom(f), do: f, else: String.to_atom(f)
    {:ok, Kernel.apply(String, f_atom, [value]), options}
  end

  defp delete(options, key) do
    Keyword.delete(options, key)
  end

  defp delete_first(options, key) do
    Keyword.delete_first(options, key)
  end
end
