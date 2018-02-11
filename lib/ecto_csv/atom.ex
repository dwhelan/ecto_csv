defmodule EctoCSV.Atom do
  @spec to_atom([String | atom]) :: [atom] 
  def to_atom(list) when is_list(list) do
    Enum.map(list, &to_atom(&1))
  end

  @spec to_atom(String | atom) :: atom
  def to_atom(string) when is_binary(string) do
    try do
      String.to_existing_atom(string)
    rescue ArgumentError -> 
      String.to_atom(string)
    end
  end
end
