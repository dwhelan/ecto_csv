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
