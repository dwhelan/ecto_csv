defmodule CSV do
  def file_has_headers?(mod) when is_atom(mod) do
    if Keyword.has_key?(mod.__info__(:functions), :__csv__) do
      mod.__csv__(:file_has_headers?)
    else
      true
    end
  end

  def file_has_headers?(struct) do
    file_has_headers?(struct.__struct__)
  end

  def headers(mod) when is_atom(mod) do
    mod.__schema__(:fields)
    |> Enum.filter(&(&1 != :id))
  end

  def headers(struct) do
    headers(struct.__struct__)
  end
end
