defmodule CSV.Column do
  def integer(string) do
    String.to_integer(string)
  end

  def input2({_name, transforms}, value) do
    transform2(value, List.wrap(transforms))
  end

  defp transform2(value, transforms) do
    Enum.reduce(transforms, {:ok, value}, fn(transform, value) -> apply_transform2(transform, value) end)
  end

  defp apply_transform2(_transform, {:error, errors}) do
    {:error, errors}
  end

  defp apply_transform2(transform, {:ok, value}) do
    try do
      {:ok, call2(transform, value) }
    rescue
      e in FunctionClauseError    -> {:error, [FunctionClauseError.message(e)]}
      e in UndefinedFunctionError -> {:error, [UndefinedFunctionError.message(e)]}
    end
  end

  defp call2(transform, value) when is_function(transform) do
    transform.(value)
  end
  
  defp call2(transform, value) do
    atom = String.to_atom(to_string(transform))
    Kernel.apply(__MODULE__, atom, [value])
  end
  
  # defp transform2({:ok, transforms, value}) do
  #   if f = options[:transform] do
  #     apply_transform(f, delete_first(options, :transform), value) |> transform
  #   else
  #     {:ok, options, value}
  #   end
  # end

  def input({_name, options}, value) do
    {:ok, options, value}
    |> parse
    |> transform
    |> result
  end

  defp parse({:ok, options, string}) do
    if type = options[:type] do
      {status, result } =  apply_parse(type, string)
      {status, delete(options, :type), result}
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

  defp apply_parse(type, string) do
    cond do
      is_a?(String,  type) -> {:ok,    string}
      is_a?(Integer, type) -> parse_integer(string)
      true                 -> {:error, ["unknown type '#{type}'"]}
    end
  end

  # @parsers %{Integer => &CSV.Column.parse_integer/1}

  defp parse_integer(string) do
    case Integer.parse(string) do
      {integer, _} -> {:ok,    integer}
      :error       -> {:error, ["'#{string}' is not an Integer"]}
    end
  end

  defp is_a?(module, type) do
    "#{module}" in ["#{type}", "Elixir.#{type}"]
  end

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
