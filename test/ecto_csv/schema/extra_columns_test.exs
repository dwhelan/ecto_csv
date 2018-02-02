defmodule EctoCSV.Schema.ExtraHeadersTest do
  use ExUnit.Case

  defmodule Default do
    use EctoCSV.Schema
    schema "test" do end
    csv do end
  end

  test "should default extra columns to :retain" do
    assert Default.__csv__(:extra_columns) == :retain
  end

  defmodule Retain do
    use EctoCSV.Schema
    schema "test" do end
    csv do extra_columns :retain end
  end

  test "should be able to set extra_columns to :retain" do
    assert Retain.__csv__(:extra_columns) == :retain
  end

  defmodule Ignore do
    use EctoCSV.Schema
    schema "test" do end
    csv do extra_columns :ignore end
  end

  test "should be able to set extra_columns to :ignore" do
    assert Ignore.__csv__(:extra_columns) == :ignore
  end
end
