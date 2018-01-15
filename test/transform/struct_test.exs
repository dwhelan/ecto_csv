defmodule Transform.StructTest do
  use ExUnit.Case
  require CSV.Transform, as: Transform

  def integer(string) do
    String.to_integer(string)
  end

  def string(value) do
    Kernel.to_string(value)
  end

  defmodule Example do
    use CSV.Schema

    columns do
      column :a
      column :b, :integer
      column :c, :float
    end
  end

  defmodule Mapping do
    use CSV.Schema

    columns do
      column :a, :string
      column :b, :integer
      column :c, :float
    end
  end
  
  describe "mapping" do
    test "foo" do
      input = %Example{a: ""}
    end
  end
end
