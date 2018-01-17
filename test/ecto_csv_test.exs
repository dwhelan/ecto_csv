defmodule EctoCSVTest do
  use ExUnit.Case

  defmodule File do
    use EctoCSV.Schema

    schema "test" do
      field :A
      field :a1
      field :a2, :integer
      field :a3, :integer, opt: "value"
    end
  end

  describe "cast" do
    test "should cast a string when type is not defined" do
      assert cast(:"A1", "foo") == {:ok, "foo"}
    end

    test "should cast to built-in data types" do
      assert cast(:a2, "1") == {:ok, 1}
    end
  end

  describe "load" do
    test "should load a string when type is not defined" do
      assert load(:"A1", "123") == {:ok, "123"}
    end

    test "should cast to built-in data types" do
      assert load(:a2, 1) == {:ok, 1}
    end
  end

  describe "dump" do
    test "should dump a string when type is not defined" do
      assert dump(:"A1", "foo") == {:ok, "foo"}
    end

    test "should dump from built-in data types" do
      assert dump(:a2, 1) == {:ok, 1}
    end
  end

  defp load(field, value) do
    EctoCSV.load(EctoCSVTest.File, field, value)
  end

  defp cast(field, value) do
    EctoCSV.cast(EctoCSVTest.File, field, value)
  end

  defp dump(field, value) do
    EctoCSV.dump(EctoCSVTest.File, field, value)
  end
end
