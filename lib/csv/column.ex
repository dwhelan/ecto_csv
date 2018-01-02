defmodule CSV.Column do

  require CSV.Invoke, as: Invoke

  def input({_name, transforms}, value, options \\ %{}) do
    transform(value, List.wrap(transforms), options)
  end

  defp transform(value, transforms, options) do
    Enum.reduce(transforms, {:ok, value}, fn(transform, value) -> apply_transform(transform, value, options) end)
  end

  defp apply_transform(_transform, {:error, errors}, _options) do
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
