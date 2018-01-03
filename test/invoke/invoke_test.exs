defmodule InvokeTest do
  use ExUnit.Case
  require Invoke

  describe "apply(fun, args) when 'fun' is an atom" do
    test "that includes a module",
      do: assert Invoke.apply(:"Integer.to_string", [123]) === "123"

    test "that does not include a module -> use Kernel",
      do: assert Invoke.apply(:hd, [[1,2,3]]) === 1

    test "with no args",
      do: assert Invoke.apply(:node, []) === :nonode@nohost

    test "with multiple args",
      do: assert Invoke.apply(:div, [6,3]) === 2
  end

  describe "apply(fun, args) when 'fun' is a binary" do
    test "that includes a module",
      do: assert Invoke.apply("Integer.to_string", [123]) === "123"

    test "that does not include a module -> use Kernel",
      do: assert Invoke.apply("hd", [[1,2,3]]) === 1

    test "with no args",
      do: assert Invoke.apply("node", []) === :nonode@nohost

    test "with multiple args",
      do: assert Invoke.apply("div", [6,3]) === 2
  end

  describe "apply(fun, args) when 'fun' is a function" do
    test "with no args",
      do: assert Invoke.apply(&node/0, []) === :nonode@nohost

    test "with one arg",
      do: assert Invoke.apply(&to_string/1, [123]) === "123"

    test "with multiple args",
      do: assert Invoke.apply(&div/2, [6,3]) === 2
  end

  describe "apply(module, fun, args) when 'module' is a module" do
    test "and 'fun' is an atom",
      do: assert Invoke.apply(Integer, :to_string, [123]) === "123"

    test "and 'fun' is a binary",
      do: assert Invoke.apply(Integer, "to_string", [123]) === "123"

    test "with no args",
      do: assert Invoke.apply(Kernel, :node, []) === :nonode@nohost

    test "with multiple args",
      do: assert Invoke.apply(Kernel, :div, [6,3]) === 2
  end

  describe "apply(module, fun, args) when 'module' is a binary" do
    test "and 'fun' is an atom",
      do: assert Invoke.apply("Integer", :to_string, [123]) === "123"

    test "and 'fun' is a binary",
      do: assert Invoke.apply("Integer", "to_string", [123]) === "123"

    test "with no args",
      do: assert Invoke.apply("Kernel", :node, []) === :nonode@nohost

    test "with multiple args",
      do: assert Invoke.apply("Kernel", :div, [6,3]) === 2
  end

  describe "apply(module, fun, args) when 'module' is an atom" do
    test "and 'fun' is an atom",
      do: assert Invoke.apply(:Integer, :to_string, [123]) === "123"

    test "and 'fun' is a binary",
      do: assert Invoke.apply(:Integer, "to_string", [123]) === "123"

    test "with no args",
      do: assert Invoke.apply(:Kernel, :node, []) === :nonode@nohost

    test "with multiple args",
      do: assert Invoke.apply(:Kernel, :div, [6,3]) === 2
  end
end
