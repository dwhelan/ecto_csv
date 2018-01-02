defmodule CSV.Transform do
  def transform(value, transforms \\ [], options \\ %{}) do
    try do {:ok, transform_all(value, transforms, options)}
    rescue e -> handle_error(e)
    catch  e -> handle_error(e)
    end
  end

  defp transform_all(value, transforms, options) do
    Enum.reduce(wrap(transforms), value, &transform_one(&1, &2, options))
  end

  defp transform_one({module, function}, value, _options) do
    invoke(module, function, value)
  end

  defp transform_one(function, value, options) do
    invoke(options[:module], function, value)
  end

  defp invoke(_module, f, value) when is_function(f) do
    f.(value)
  end

  defp invoke(module, f_name, value) do
    CSV.Invoke.apply(wrap(module), f_name, [value])
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

  defp wrap(value) do
    List.wrap(value)
  end
end
