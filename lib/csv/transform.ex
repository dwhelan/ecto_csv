defmodule CSV.Transform do
  require CSV.Invoke, as: Invoke

  def transform(value, transforms, options \\ %{}) do
    Enum.reduce(List.wrap(transforms), {:ok, value}, fn(transform, value) -> transform_one(transform, value, options) end)
  end

  defp transform_one(_, {:error, errors}, _) do
    {:error, errors}
  end

  defp transform_one({module, f_name}, {:ok, value}, _options) do
    invoke(module, f_name, value)
  end

  defp transform_one(f_name, {:ok, value}, options) do
    modules = options[:module] || []
    invoke(modules, f_name, value)
  end

  defp invoke(module, f_name, value) do
    try do
      {:ok, Invoke.apply(module, f_name, value) }
    rescue 
      e -> handle_error(e)
    catch
      e -> handle_error(e)
    end
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
