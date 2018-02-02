defmodule EctoCSV do
  alias Ecto.Type

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
