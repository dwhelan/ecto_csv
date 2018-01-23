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
end
