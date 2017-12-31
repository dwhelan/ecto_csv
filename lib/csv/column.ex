defmodule CSV.Column do
  def input({_name, options}, value) do
    {:ok, value, options}
    |> type
    |> transform
    |> result
  end

  defp type({:ok, value, options}) do
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

  defp delete(options, key) do
    Keyword.delete(options, key)
  end

  defp delete_first(options, key) do
    Keyword.delete_first(options, key)
  end

  defp parse(Integer, value),
    do: String.to_integer(value)

  defp parse(String, value),
    do: value

  defp transform(f, value) do
    f.(value)
  end
end
