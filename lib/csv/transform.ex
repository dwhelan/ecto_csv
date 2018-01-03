defmodule CSV.Transform do
  require CSV.Invoke, as: Invoke

  def transform(value, transforms \\ [], options \\ %{}) do
    try do {:ok, transform_all(value, transforms, options)}
    rescue e -> handle_error(e)
    catch  e -> handle_error(e)
    end
  end

  defp transform_all(value, transforms, options) do
    Enum.reduce(List.wrap(transforms), value, &transform_one(&1, &2, options))
  end

  defp transform_one({module, fun}, value, _options) do
    invoke(module, fun, [value])
  end

  defp transform_one(fun, value, options) do
    invoke(options[:module], fun, [value])
  end

  defp invoke(module, fun, args) do
    case module do
      nil -> Invoke.apply(fun, args)
      _   -> Invoke.apply(module, fun, args)
    end
  end

  defp handle_error(e) do
    {:error, error_message(e)}
  end

  defp error_message(string) when is_binary(string) do
    string
  end

  defp error_message(e) do
    try do e.__struct__.message(e)
    rescue UndefinedFunctionError -> inspect(e)
    end 
  end
end
