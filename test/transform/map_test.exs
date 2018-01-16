defmodule Transform.StructTest do
  use ExUnit.Case
  alias Transform.Map

  defmodule Source do
    defstruct [:a, :b, :c]
  end

  defmodule Target do
    defstruct [:a, :b, :c]
  end

  @fields [a: "a", b: 42, c: false]
  
  describe "supported types" do
    test "struct -> struct" do
      assert %Target{a: "a", b: 42, c: false} = %Source{a: "a", b: 42, c: false} |> Map.cast(Target)
    end

    test "struct -> map" do
      assert %{a: "a", b: 42, c: false} = %Source{a: "a", b: 42, c: false} |> Map.cast(%{})
    end

    test "map -> struct" do
      assert %Target{a: "a", b: 42, c: false} = %{a: "a", b: 42, c: false} |> Map.cast(Target)
    end

    test "map -> map" do
      assert %{a: "a", b: 42, c: false} = %{a: "a", b: 42, c: false} |> Map.cast(%{})
    end
  end

  test "should default to creating a target map" do
    assert %{a: "a", b: 42, c: false} = %{a: "a", b: 42, c: false} |> Map.cast
  end
end
