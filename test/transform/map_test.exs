defmodule Transform.StructTest do
  use ExUnit.Case
  alias Transform.Map

  defmodule Source do
    defstruct [:a, :b, :c]
  end

  defmodule Target do
    defstruct [:a, :b, :c]
  end

  describe "supported types" do
    test "struct -> struct" do
      assert Map.cast(source(), Target) == target()
    end

    test "struct -> map" do
      assert Map.cast(source(), %{}) == map()
    end

    test "map -> struct" do
      assert Map.cast(map(), Target) == target()
    end

    test "map -> map" do
      assert Map.cast(map(), %{}) == map()
    end
  end

  test "should default to creating a target map" do
    assert Map.cast(source()) == map()
  end

  defp source, do: %Source{a: "a", b: 42, c: false}
  defp target, do: %Target{a: "a", b: 42, c: false}
  defp map,    do:       %{a: "a", b: 42, c: false}
end
