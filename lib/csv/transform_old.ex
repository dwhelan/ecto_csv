defmodule CSV.TransformOld do
  defmacro __using__(_name) do
    quote do
      import unquote(__MODULE__)
    end
  end

#  Enum.each([:downcase, :upcase], fn fn_name ->
#    quote bind_quoted: [fn_name: fn_name] do
#      macro_name = Atom.to_string(fn_name)
#      IO.puts "Defining macro for #{fn_name}"
#      defmacro unquote(macro_name)(value) do
#        call fn_name, value
#      end
#    end
#  end)

  defmacro downcase(value) when is_binary(value) do
    call :downcase, value
  end

  defmacro upcase(value) when is_binary(value) do
    call :upcase, value
  end

  defp call(fn_name, value) do
    call(fn_name, value, [])
  end

  defp call(fn_name, value, args) do
    quote bind_quoted: [fn_name: fn_name, value: value, args: args] do
      apply(String, fn_name, [value | args])
    end
  end
end
