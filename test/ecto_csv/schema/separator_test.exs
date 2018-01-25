defmodule EctoCSV.Schema.SeparatorTest do
  use ExUnit.Case

  defmodule Example do
    use EctoCSV.Schema

    csv do
    end
  end

  test "with empty csv block 'separator' should be a comma'" do
    assert Example.__csv__(:separator) == ","
  end  

  defmodule Example2 do
    use EctoCSV.Schema

    csv do
      separator "|"
    end
  end

  test "'separators' should be set from 'separator''" do
    assert Example2.__csv__(:separator) == "|"
  end

  require CompileTimeAssertions

  describe "separator validation" do
    test "that separator cannot be more than one character" do
      code =
      """
        defmodule Example2 do
          use EctoCSV.Schema
      
          csv do
            separator "ab"
          end
        end
      """
      CompileTimeAssertions.assert_error(ArgumentError, "separator 'ab' cannot be more than one character", code)
    end

    test "that separator must be a string" do
      code =
      """
        defmodule Example2 do
          use EctoCSV.Schema
      
          csv do
            separator 1
          end
        end
      """
      CompileTimeAssertions.assert_error(ArgumentError, "separator '1' is invalid. It must be a string enclosed in double quotes", code)
    end
  end
end
