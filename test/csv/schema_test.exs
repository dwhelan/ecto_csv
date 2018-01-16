defmodule CSV.SchemaTest do
  use ExUnit.Case
  import CompileTimeAssertions

  defmodule File do
    use CSV.Schema

    columns do
      # atom column names
      column :A
      column :a1
      column :a2, :integer
      column :a3, :integer, opt: "value"
  
      # string column names
      column "B1"
      column "B2", :integer
      column "B3", :integer, opt: "value"
    end
  end

  describe "that columns names" do
    test "should support upper case atoms" do
      assert record_has_key? :"A"
    end  

    test "should support atoms" do
      assert record_has_key? :a1
    end  

    test "should support atoms with a type" do
      assert record_has_key? :a2
    end

    test "should support atoms with a type and options" do
      assert record_has_key? :a3
    end

    test "should support string names" do
      assert record_has_key? :"B1"
    end

    test "should support string names with a type" do
      assert record_has_key? :"B2"
    end

    test "should support string names with a type and options" do
      assert record_has_key? :"B3"
    end
  end

  describe "cast" do
    test "should cast a string when type is not defined" do
      assert cast(:"A1", "foo") == "foo"
    end

    test "should cast to built-in data types" do
      assert cast(:a2, "1") == 1
    end
  end

  describe "dump" do
    test "should dump a string when type is not defined" do
      assert dump(:"A1", "foo") == "foo"
    end

    test "should dump from built-in data types" do
      assert dump(:a2, 1) == 1
    end
  end

  describe "direct calls to Ecto.Schema should raise compilation errors" do
    test "schema 'name'" do
      assert_compile_error ~r{schema/2 imported from both Ecto.Schema and CSV.Schema}, 
        """
        defmodule Bad do
          use CSV.Schema
      
          schema "test" do
          end
        end
        """
    end

    test "field :name" do
      assert_compile_error ~r{field/1 imported from both Ecto.Schema and CSV.Schema}, 
        """
        defmodule Bad do
          use CSV.Schema
      
          columns do
            field :name
          end
        end
        """
    end

    test "field :name, :integer" do
      assert_compile_error ~r{field/2 imported from both Ecto.Schema and CSV.Schema}, 
        """
        defmodule Bad do
          use CSV.Schema
      
          columns do
            field :name, :integer
          end
        end
        """
    end

    test "field :name, :integer, opt: 'value'" do
      assert_compile_error ~r{field/3 imported from both Ecto.Schema and CSV.Schema}, 
        """
        defmodule Bad do
          use CSV.Schema
      
          columns do
            field :name, :integer, opt: 'value'
          end
        end
        """
    end
  end

  defp record_has_key?(key) do
    record = struct(CSV.SchemaTest.File)
    Map.has_key?(record, key)
  end

  defp cast(field, value) do
    CSV.Schema.cast(CSV.SchemaTest.File, field, value)
  end

  defp dump(field, value) do
    CSV.Schema.dump(CSV.SchemaTest.File, field, value)
  end
end
