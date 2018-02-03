defmodule EctoCSV.Loader.HeaderTest do
  alias EctoCSV.LoadError
  use ExUnit.Case
  
  defmodule Default do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
    end
  end

  test "header will default to 'true'" do
    assert %{a: "1", b: "2"} = load(["a,b", "1,2"], Default)
  end

  test "values will be assigned based on the header order in the loaded file" do
    assert %{a: "1", b: "2"} = load(["b,a", "2,1"], Default)
  end

  test "that an error will be raised if a blank header is found" do
    assert_raise LoadError, "blank header found on line 1", fn ->
      load(["b,", "2,1"], Default)
   end 
 end

  defmodule HeadersTrue do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      header true
    end
  end

  test "header will be loaded when header is 'true'" do
    assert %{a: "1", b: "2"} = load(["a,b", "1,2"], HeadersTrue)
  end

  defmodule HeadersFalse do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      header false
    end
  end

  test "header will be from schema when header is 'false'" do
    assert %{a: "1", b: "2"} = load(["1,2"], HeadersFalse)
  end

  defp load(path, schema) do
    hd(EctoCSV.Loader.load(path, schema) |> Enum.take(1))
  end
end
