defmodule CSV.Column do

  require CSV.Invoke, as: Invoke

  def transform(transforms, value, options \\ %{}) do
    Enum.reduce(List.wrap(transforms), {:ok, value}, fn(transform, value) -> apply_transform(transform, value, options) end)
  end

  defp apply_transform(_, {:error, errors}, _) do
    {:error, errors}
  end

  defp apply_transform(transform, {:ok, value}, options) do
    try do
      {:ok, Invoke.call(transform, value, options[:modules] || []) }
    rescue
      e in FunctionClauseError    -> {:error, [FunctionClauseError.message(e)]}
      e in UndefinedFunctionError -> {:error, [UndefinedFunctionError.message(e)]}
    end
  end
end
