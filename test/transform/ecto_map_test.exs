defmodule Transform.EctoMapTest do
  use ExUnit.Case
  alias Transform.Map

  defmodule Example do
    use CSV.Schema

    schema "test" do
      field :a
      field :b, :integer
      field :c, :float
    end
  end

  defmodule Result do
    use CSV.Schema

    schema "test" do
      field :a, :string
      field :b, :integer
      field :c, :float
    end
  end

  describe "mapping" do
    test "struct to struct" do
      assert %Result{a: "123"} = %Example{a: "123"} |> Map.cast(Result)
    end
  end
end
