defmodule CSV.Column do
  def input({_name, options}, value) do
    {:ok, value, options}
    |> parse
    |> transform
    |> result
  end

  defp parse({:ok, value, options}) do
    if type = options[:type] do
      _parse(type, value, delete(options, :type))
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

  defp transform({status, value, options}) do
    {status, value, options}
  end

  defp result{status, value, _options} do
    {status, value}
  end

  defp _parse(type, value, options) when type in [String, "String"],
     do: {:ok, value, options}

  defp _parse(type, value, options) when type in [Integer, "Integer"] do
    case Integer.parse(value) do
      {integer, _} -> {:ok, integer, options}
      :error       -> {:error, ["'#{value}' is not an Integer"], options}
    end
  end

  defp _parse(type, _value, options),
    do: {:error, ["unknown type '#{type}'"], options}

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
