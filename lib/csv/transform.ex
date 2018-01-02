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

  defp handle_error(e) when is_binary(e) do
    {:error, e}
  end

  defp handle_error(e) when is_map(e) do
    {:error, e.__struct__.message(e)}
  end
end
