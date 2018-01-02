defmodule CSV.Transform do
  require CSV.Invoke, as: Invoke

  def transform(value, transforms, options \\ %{}) do
    Enum.reduce(List.wrap(transforms), {:ok, value}, fn(transform, value) -> transform_one(transform, value, options) end)
  end

  defp transform_one(_, {:error, errors}, _) do
    {:error, errors}
  end

  defp transform_one(transform, {:ok, value}, options) do
    try do
      {:ok, Invoke.call(transform, value, options[:modules] || []) }
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
