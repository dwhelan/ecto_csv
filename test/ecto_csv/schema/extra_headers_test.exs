defmodule EctoCSV.Schema.ExtraHeadersTest do
  use ExUnit.Case

  defmodule Example do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
      field :c
    end

    csv do
    end
  end
end
