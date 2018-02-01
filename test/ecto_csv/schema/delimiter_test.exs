defmodule EctoCSV.Schema.DelimiterTest do
  use ExUnit.Case

  defmodule Default do
    use EctoCSV.Schema

    csv do
    end
  end

  test "with empty csv block 'delimiter' should be a \r\n'" do
    assert Default.__csv__(:delimiter) == "\r\n"
  end  

  defmodule LineFeed do
    use EctoCSV.Schema

    csv do
      delimiter "\n"
    end
  end

  test "delimiter can be set to '\n'" do
    assert LineFeed.__csv__(:delimiter) == "\n"
  end

  defmodule CarriageReturnLineFeed do
    use EctoCSV.Schema

    csv do
      delimiter "\r\n"
    end
  end

  test "delimiter can be set to '\r\n'" do
    assert CarriageReturnLineFeed.__csv__(:delimiter) == "\r\n"
  end

  require CompileTimeAssertions

  describe "delimiter validation" do
    test "that delimiter cannot be an empty string" do
      code =
      """
        defmodule Example do
          use EctoCSV.Schema
      
          csv do
            delimiter ""
          end
        end
      """
      CompileTimeAssertions.assert_error(ArgumentError, ~s[delimiter is invalid. It must be either "\\n" or "\\r\\n"], code)
    end

    test "that delimiter cannot be an arbitrary string" do
      code =
      """
        defmodule Example do
          use EctoCSV.Schema
      
          csv do
            delimiter "x"
          end
        end
      """
      CompileTimeAssertions.assert_error(ArgumentError, ~s[delimiter is invalid. It must be either "\\n" or "\\r\\n"], code)
    end
  end
end
