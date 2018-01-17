defmodule CSV.SchemaTest do
  use ExUnit.Case

  defmodule File do
    use CSV.Schema

    schema "test" do
      field :A
      field :a1
      field :a2, :integer
      field :a3, :integer, opt: "value"
    end
  end

  describe "that field names" do
    test "should support upper case atoms" do
    end  
  end
end
