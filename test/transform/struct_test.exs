defmodule Transform.StructTest do
  use ExUnit.Case
  require CSV.Transform, as: Transform

  defmodule Example do
    use CSV.Schema

    columns do
      column :a
      column :b, :integer
      column :c, :float
    end
  end

  defmodule Result do
    use CSV.Schema

    columns do
      column :a, :string
      column :b, :integer
      column :c, :float
    end
  end
  
  defmodule Transform do
    def cast(struct, module) do
      keys = 
      Map.keys(struct)
      |> remove_meta_keys
      |> copy_values(struct, module)
    end

    @does_not_start_with__ ~r/^(?!__).+/
    defp remove_meta_keys(keys) do
      Enum.filter(keys, fn key ->
        Regex.match?(@does_not_start_with__, Atom.to_string(key))
      end)
    end

    defp copy_values(keys, struct, module) do
      Enum.reduce(keys, struct(module), fn key, result ->
        value = Map.get(struct, key)
        Map.put(result, key, value)
      end)
    end
  end

  describe "mapping" do
    test "foo" do
      input = %Example{a: "123"}
      output = Transform.cast(input, Result)
      assert %Result{a: "123"} = output
    end
  end
end
