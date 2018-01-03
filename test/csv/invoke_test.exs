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
    test "when 'fun' is an atom that includes a module",
      do: assert Invoke.apply(:"Integer.to_string", [123]) === "123"

    test "when 'fun' is an atom ",
      do: assert Invoke.apply(:hd, [[1,2,3]]) === 1

    test "when 'fun' is a string that includes a module",
      do: assert Invoke.apply("Integer.to_string", [123]) === "123"

    test "when 'fun' is a string ",
      do: assert Invoke.apply("hd", [[1,2,3]]) === 1

      test "when 'fun' is a function",
      do: assert Invoke.apply(&to_string/1, [123]) === "123"
  end

  # describe "apply(module, fun, args)" do
  #   test "when 'module' and 'fun' are atoms" do
  #     assert Invoke.apply(String, :to_integer, "123") ===  123
  #   end
  # end
end
