includes = []
excludes = [:wip, :skip]

# Uncomment the line below to enable focus mode
# includes = [:focus | includes]; excludes = [:test | excludes]

ExUnit.start(include: includes, exclude: excludes)

# From https://gist.github.com/henrik/1054546364ac68da4102
defmodule CompileTimeAssertions do
  defmacro assert_compile_error(expected_message, code) do
    quote do
      assert_raise unquote(CompileError), unquote(expected_message), fn ->
        Code.eval_string(unquote(code))
      end
    end
  end

  # defmacro assert_compile_error(expected_exception, expected_message, fun) do
  #   # At compile-time, the fun is in AST form and thus cannot raise.
  #   # At run-time, we will evaluate this AST, and it may raise.
  #   fun_quoted_at_runtime = Macro.escape(fun)

  #   quote do
  #     assert_raise unquote(expected_exception), unquote(expected_message), fn ->
  #       Code.eval_quoted(unquote(fun_quoted_at_runtime))
  #     end
  #   end
  # end
end

defmodule TestFile do 
  def create(content \\ "") do
    path = Briefly.create!
    File.write!(path, content)
    path
  end

  def create_pair(content \\ "") do
    {create(content), create()}
  end
end