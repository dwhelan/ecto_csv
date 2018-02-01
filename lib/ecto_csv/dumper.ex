defmodule EctoCSV.Dumper do
  alias EctoCSV.Adapters.CSV

  def dump(stream, path) do
    dump(stream) |> Enum.into(File.stream!(path))
  end

  def dump(stream) do
    schema = extract_schema(stream)
    stream
    |> to_values
    |> to_csv(schema)
  end

  defp to_values(stream) do
    Stream.transform(stream, 0, fn struct, index -> {row_values(struct, index), index + 1} end )
  end

  defp extract_schema(stream) do
    struct = hd(Enum.take(stream , 1))
    struct.__struct__
  end  

  defp to_csv(stream,schema) do
    stream
    |> CSV.encode(schema)
    # |> Formatter.dump_to_stream
    # |> Stream.map(&IO.iodata_to_binary(&1))    
  end

  defp row_values(struct, index) do
    if index == 0 && EctoCSV.file_has_header?(struct) do
      [EctoCSV.headers(struct), row_values(struct)]
    else
      [row_values(struct)]
    end
  end

  defp row_values(struct) do
    Enum.map(EctoCSV.headers(struct), &struct_value(struct, &1))
  end

  defp struct_value(struct, field) do
    Map.get(struct, field) || ""
  end
end
