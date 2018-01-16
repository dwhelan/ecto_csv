defmodule Transform.EctoMapTest do
  use ExUnit.Case
  alias Transform.Map

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

  describe "mapping" do
    test "struct to struct" do
      assert %Result{a: "123"} = %Example{a: "123"} |> Map.cast(Result)
    end
  end
end
