defmodule CSV.Transform do
  require CSV.Invoke, as: Invoke

  def transform(value, transforms, options \\ %{}) do
    try do
      Enum.reduce(List.wrap(transforms), {:ok, value}, fn(transform, value) -> transform_one(transform, value, options) end)
    rescue 
      e -> handle_error(e)
    catch
      e -> handle_error(e)
    end
  end

  defp transform_one({module, function}, {:ok, value}, _options) do
    invoke(module, function, value)
  end

  defp transform_one(function, {:ok, value}, options) do
    invoke(List.wrap(options[:module]), function, value)
  end

  defp invoke(_module, f, value) when is_function(f) do
    {:ok, f.(value)}
  end

  defp invoke(module, f_name, value) do
    {:ok, Invoke.apply(module, f_name, [value])}
  end

  defp handle_error(e) do
    {:error, error_message(e)}
  end

  defp error_message(string) when is_binary(string) do
    string
  end

  defp error_message(e) do
    try do
      e.__struct__.message(e)
    rescue
      UndefinedFunctionError -> inspect(e)
    end 
  end
end
