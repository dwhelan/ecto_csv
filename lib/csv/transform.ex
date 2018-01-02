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
      e in FunctionClauseError    -> {:error, [FunctionClauseError.message(e)]}
      e in UndefinedFunctionError -> {:error, [UndefinedFunctionError.message(e)]}
    end
  end
end
