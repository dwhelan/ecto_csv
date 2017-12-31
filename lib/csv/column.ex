defmodule CSV.Column do
  def input({_name, options}, value) do
    {:ok, value, options}
    |> parse
    |> transform
    |> result
  end

  defp parse({:ok, value, options}) do
    if type = options[:type] do
      {:ok, parse(type, value), delete(options, :type)}
    else
      {:ok, value, options}
    end
  end

  defp transform({:ok, value, options}) do
    if transform = options[:transform] do
      {:ok, transform(transform, value), delete_first(options, :transform)}
    else
      {:ok, value, options}
    end
  end

  defp result{status, value, _options} do
    {status, value}
  end

  defp parse(type, value) when type in [Integer, "Integer"],
    do: String.to_integer(value)

  defp parse(type, value) when type in [String, "String"],
    do: value

  defp transform(function, value) when is_function(function) do
    function.(value)
  end

  defp delete(options, key) do
    Keyword.delete(options, key)
  end

  defp delete_first(options, key) do
    Keyword.delete_first(options, key)
  end
end
