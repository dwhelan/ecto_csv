defmodule CSV.Transforms do
  defmacro __using__(_name) do
    quote do
      import unquote(__MODULE__)
    end
  end
  
  defp call(name, string, args \\ Macro.escape([])) do
    quote do 
      apply(String, unquote(name), [unquote(string) | unquote(args)])
    end
  end
  
  defmacro downcase(value) do
    call :downcase, value
    # quote do String.downcase(unquote(value)) end
  end
  
  defmacro upcase(value) do
    call :upcase, value
    # quote do String.upcase(unquote(value)) end
  end
  
end
