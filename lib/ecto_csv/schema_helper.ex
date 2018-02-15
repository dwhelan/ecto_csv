defmodule EctoCSV.SchemaHelper do
  alias EctoCSV.Schema

  @moduledoc false
  @doc false

  @spec type(Schema, atom) :: atom
  def type(schema, field) do
    schema.__schema__(:type, field) || :string
  end

  @spec file_has_header?(Schema) :: boolean
  def file_has_header?(schema) do
    schema.__csv__ :file_has_header?
  end

  @spec headers(Schema) :: [atom]
  def headers(schema) do
    schema.__csv__ :headers
  end

  @spec extra_columns(Schema) :: atom
  def extra_columns(schema) do
    schema.__csv__ :extra_columns
  end

  @spec separator(Schema) :: String
  def separator(schema) do
    schema.__csv__ :separator
  end

  @spec delimiter(Schema) :: String
  def delimiter(schema) do
    schema.__csv__ :delimiter
  end
end
