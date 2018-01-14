defmodule CSV.EctoTest do
  use Ecto.Schema
  use ExUnit.Case

  schema "test" do
    field :name
    field :married, :boolean
    field :age,     :integer, default: 18
  end

  describe "that a field with only an atom" do
    test "has its module set to :string" do
      assert type(:name) === :string
    end
    
    test "has an value of 'nil'" do
      assert %CSV.EctoTest{}.name == nil
    end    
  end

  describe "that a field with a type" do
    test "has its type set" do
      assert type(:married) === :boolean
    end
    
    test "has an value of 'nil'" do
      assert %CSV.EctoTest{}.married == nil
    end    
  end

  describe "that a field with a type and default" do
    test "has its type set" do
      assert type(:age) === :integer
    end
    
    test "has an initial value from the :default option" do
      assert %CSV.EctoTest{}.age == 18
    end    
  end

  defp type(atom) do
    __changeset__()[atom]
  end
end
