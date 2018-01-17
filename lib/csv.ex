defmodule CSV do
  alias Ecto.Type

  def file_has_header?(mod) when is_atom(mod) do
    if Keyword.has_key?(mod.__info__(:functions), :__csv__) do
      mod.__csv__(:file_has_header?)
    else
      true
    end
  end

  def file_has_header?(struct) do
    file_has_header?(struct.__struct__)
  end

  def headers(mod) when is_atom(mod) do
    mod.__schema__(:fields) |> Enum.filter(&(&1 != :id))
  end

  def headers(struct) do
    headers(struct.__struct__)
  end

  def load(mod, field, value) do
    type(mod, field) |> Type.load(value)
  end

  def cast(mod, field, value) do
    type(mod, field) |> Type.cast(value)
  end

  def dump(mod, field, value) do
    type(mod, field) |> Type.dump(value)
  end

  defp type(mod, field) do
    mod.__schema__(:type, field) || :string
  end
end
