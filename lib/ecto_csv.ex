defmodule EctoCSV do
  alias Ecto.Type

  def file_has_header?(schema) when is_atom(schema) do
    if Keyword.has_key?(schema.__info__(:functions), :__csv__) do
      schema.__csv__(:file_has_header?)
    else
      true
    end
  end

  def file_has_header?(struct) do
    file_has_header?(struct.__struct__)
  end

  def headers(schema) when is_atom(schema) do
    schema.__csv__(:headers)
  end

  def headers(struct) do
    headers(struct.__struct__)
  end

  def load(schema, field, value) do
    type(schema, field) |> Type.load(value)
  end

  def cast(schema, field, value) do
    type(schema, field) |> Type.cast(value)
  end

  def dump(schema, field, value) do
    type(schema, field) |> Type.dump(value)
  end

  defp type(schema, field) do
    schema.__schema__(:type, field) || :string
  end
end
