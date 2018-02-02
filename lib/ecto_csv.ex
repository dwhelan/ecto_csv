defmodule EctoCSV do
  alias Ecto.Type

  
  def dump(schema, field, value) do
    type(schema, field) |> Type.dump(value)
  end
  
  defp type(schema, field) do
    schema.__schema__(:type, field) || :string
  end
end
