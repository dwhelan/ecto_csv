defmodule Transform.EctoStructTest do
  use ExUnit.Case
  alias Transform.Struct

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
    test "foo" do
      input = %Example{a: "123"}
      output = Struct.cast(input, Result)
      assert %Result{a: "123"} = output
    end
  end
end
