defmodule EctoCSV.Loader.Header do
  alias EctoCSV.Adapters.CSV
  alias EctoCSV.LoadError

  def remove_header(stream) do
    Stream.transform(stream, 0, fn struct, index -> 
      case index do
        0 -> {[],       :ignore_header}
        _ -> {[struct], :process_stream}
      end
    end)
  end

  def file_headers(stream, schema) do
    stream
    |> read(schema)
    |> take_header
    |> ensure_valid_headers(schema)
  end

  defp read(stream, schema) do
    CSV.read(stream, options(schema))
  end

  defp options(schema) do
    [
      separator: separator(schema),
      delimiter: delimiter(schema)
    ]
  end

  defp take_header(stream) do
    stream |> Enum.take(1) |> List.first |> to_atom
  end

  defp ensure_valid_headers(headers, schema) do    
    if Enum.filter(headers, &(String.length(Atom.to_string(&1)) == 0)) |> length > 0 do
      raise LoadError.exception(line: 1, message: "blank header found")
    end

    if length(missing = headers(schema) -- headers) > 0 do
      missing = Enum.join(missing, ",")
      raise LoadError.exception(line: 1, message: "missing headers '#{missing}'")
    end

    if length(duplicates = headers -- Enum.uniq(headers)) > 0 do
      duplicates = Enum.uniq(duplicates) |> Enum.join(",")
      raise LoadError.exception(line: 1, message: "duplicate headers '#{duplicates}' found")
    end

    if length(headers) > length(headers(schema)) and extra_columns(schema) == :error do
      extras = Enum.join(headers -- headers(schema), ",")
      raise LoadError.exception(line: 1, message: "extra headers '#{extras}' found")
    end

    headers
  end

  defp headers(schema) do
    schema.__csv__ :headers
  end

  defp extra_columns(schema) do
    schema.__csv__ :extra_columns
  end

  defp separator(schema) do
    schema.__csv__ :separator
  end

  defp delimiter(schema) do
    schema.__csv__ :delimiter
  end

  defp to_atom(list) when is_list(list) do
    list |> Enum.map(&to_atom(&1))
  end

  defp to_atom(string) when is_binary(string) do
    try do
      String.to_existing_atom(string)
    rescue ArgumentError -> 
      String.to_atom(string)
    end
  end
end
