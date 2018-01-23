defmodule EctoCSV.Schema.DelimiterTest do
  use ExUnit.Case

  defmodule Example do
    use EctoCSV.Schema

    csv do
    end
  end

  test "with empty csv block 'delimiter' should be a comma'" do
    assert Example.__csv__(:delimiter) == ","
  end  

  defmodule Example2 do
    use EctoCSV.Schema

    csv do
      delimiter "|"
    end
  end

  test "'delimiters' should be set from 'delimiter''" do
    assert Example2.__csv__(:delimiter) == "|"
  end

  require CompileTimeAssertions

  describe "delimiter validation" do
    test "that delimiter cannot be more than one character" do
      code =
      """
        defmodule Example2 do
          use EctoCSV.Schema
      
          csv do
            delimiter "ab"
          end
        end
      """
      CompileTimeAssertions.assert_error(ArgumentError, "delimiter 'ab' cannot be more than one character", code)
    end

    test "that delimiter must be a string" do
      code =
      """
        defmodule Example2 do
          use EctoCSV.Schema
      
          csv do
            delimiter 1
          end
        end
      """
      CompileTimeAssertions.assert_error(ArgumentError, "delimiter '1' is invalid. It must be a string enclosed in double quotes", code)
    end
  end
end
