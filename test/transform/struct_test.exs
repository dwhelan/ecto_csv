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
    def cast(struct, mod) do
      Map.keys(struct)
      |> remove_meta_keys
      |> copy_values(struct, mod)
    end

    @does_not_start_with__ ~r/^(?!__).+/
    defp remove_meta_keys(keys) do
      Enum.filter(keys, &Regex.match?(@does_not_start_with__, Atom.to_string(&1)))
    end

    defp copy_values(keys, struct, mod) do
      Enum.reduce(keys, struct(mod), &Map.put(&2, &1, Map.get(struct, &1)))
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
