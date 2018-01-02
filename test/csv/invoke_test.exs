defmodule CSV.InvokeTest do
  use ExUnit.Case
  require CSV.Invoke, as: Invoke

  def to_int(string) do
    String.to_integer(string)
  end

  def int_to_string(value) when is_integer(value) do
    Integer.to_string(value)
  end

  describe "apply(fun, args)" do
    test "when 'fun' is a function" do
      assert Invoke.apply(&to_int/1, ["123"]) === 123
    end
  end

  describe "apply(module, fun, args)" do
    test "when 'module' and 'fun' are atoms" do
      assert Invoke.apply(Enum, :reverse, [[1, 2, 3]]) ===  [3, 2, 1]
    end
  end
end
