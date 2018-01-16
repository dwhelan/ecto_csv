defmodule CSV do
  def has_headers?(mod) when is_atom(mod) do
    if Keyword.has_key?(mod.__info__(:functions), :__csv__) do
      mod.__csv__(:headers)
    else
      true
    end
  end

  def has_headers?(struct) do
    has_headers?(struct.__struct__)
  end

  def headers(mod) when is_atom(mod) do
    mod.__schema__(:fields)
    |> Enum.filter(&(&1 != :id))
  end

  def headers(struct) do
    headers(struct.__struct__)
  end
end
