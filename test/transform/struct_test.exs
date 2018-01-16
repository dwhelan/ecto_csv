defmodule Transform.StructTest do
  use ExUnit.Case
  alias Transform.Struct

  defmodule Example do
    defstruct [:a, :b, :c]
  end

  defmodule Result do
    defstruct [:a, :b, :c]
  end

  test "can copy all values to a new object" do
    assert %Result{a: "a", b: 42, c: false} = Struct.cast(%Example{a: "a", b: 42, c: false}, Result)
  end

  test "can copy all values to a a struct" do
    assert %{a: "a", b: 42, c: false} = Struct.cast(%Example{a: "a", b: 42, c: false}, %{})
  end
end
