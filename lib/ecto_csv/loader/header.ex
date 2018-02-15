defmodule EctoCSV.Loader.Header do
  @moduledoc false
  alias EctoCSV.Adapters.CSV
  alias EctoCSV.LoadError
  import EctoCSV.Atom
  import EctoCSV.SchemaHelper

  @spec remove_header(Stream.t) :: Stream.t
  def remove_header(stream) do
    Stream.transform(stream, 0, fn struct, index -> 
      case index do
        0 -> {[],       :ignore_header}
        _ -> {[struct], :process_stream}
      end
    end)
  end

  @spec file_headers(Stream.t, EctoCSV.Schema) :: [atom] | no_return()
  def file_headers(stream, schema) do
    stream
    |> read(schema)
    |> take_header
    |> ensure_valid_headers(schema)
  end

  @spec read(Stream.t, EctoCSV.Schema) :: Stream.t
  defp read(stream, schema) do
    CSV.read(stream, options(schema))
  end

  @spec options(EctoCSV.Schema) :: Keyword.t
  defp options(schema) do
    [
      separator: separator(schema),
      delimiter: delimiter(schema)
    ]
  end

  @spec take_header(Stream.t) :: [atom]
  defp take_header(stream) do
    stream |> Enum.take(1) |> List.first |> to_atom
  end

  @spec ensure_valid_headers([atom], EctoCSV.Schema) :: [atom] | no_return()
  defp ensure_valid_headers(headers, schema) do    
    if headers |> Enum.filter(& blank? &1) |> length > 0 do
      raise LoadError.exception(line: 1, message: "blank header found")
    end

    missing = headers(schema) -- headers
    if length(missing) > 0 do
      missing = Enum.join(missing, ",")
      raise LoadError.exception(line: 1, message: "missing headers '#{missing}'")
    end

    duplicates = headers -- Enum.uniq(headers)
    if length(duplicates) > 0 do
      duplicates = duplicates |> Enum.uniq |> Enum.join(",")
      raise LoadError.exception(line: 1, message: "duplicate headers '#{duplicates}' found")
    end

    if length(headers) > length(headers(schema)) and extra_columns(schema) == :error do
      extras = Enum.join(headers -- headers(schema), ",")
      raise LoadError.exception(line: 1, message: "extra headers '#{extras}' found")
    end

    headers
  end

  @spec blank?(atom) :: boolean
  defp blank?(atom) do
    String.length(Atom.to_string(atom)) == 0
  end
end
