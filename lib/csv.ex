defmodule CSV do
  def has_headers?(mod) do
    if Keyword.has_key?(mod.__info__(:functions), :__csv__) do
      mod.__csv__(:headers)
    else
      true
    end
  end

  def headers(mod) do
    mod.__schema__(:fields)
    |> Enum.filter(&(&1 != :id))
    |> Enum.map(&(Atom.to_string(&1)))
  end

end