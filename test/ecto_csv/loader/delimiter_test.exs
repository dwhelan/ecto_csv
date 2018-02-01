defmodule EctoCSV.Loader.DelimiterTest do
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

  describe "that default delimiter" do
    test "will allow 'CRLF' delimiter in files" do
      path = TestFile.create("a,b\r\n1,2\r\n")
      assert %{a: "1", b: "2"} = load(path, Default)
    end

    test "will allow 'LF' delimiter in files" do
      path = TestFile.create("a,b\n1,2\n")
      assert %{a: "1", b: "2"} = load(path, Default)
    end
  end

  defmodule LF do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      delimiter "\n"
    end
  end

  describe "that delimiter set to LF" do
    test "will allow 'CRLF' in files" do
      path = TestFile.create("a,b\r\n1,2\r\n")
      assert %{a: "1", b: "2"} = load(path, LF)
    end

    test "will allow allow 'LF' in files" do
      path = TestFile.create("a,b\n1,2\n")
      assert %{a: "1", b: "2"} = load(path, LF)
    end
  end

  defmodule CRLF do
    use EctoCSV.Schema

    schema "test" do
      field :a
      field :b
    end

    csv do
      delimiter "\r\n"
    end
  end

  describe "that delimiter set to CRLF" do
    test "will allow 'CRLF' in files" do
      path = TestFile.create("a,b\r\n1,2\r\n")
      assert %{a: "1", b: "2"} = load(path, CRLF)
    end

    test "will allow allow 'LF' in files" do
      path = TestFile.create("a,b\n1,2\n")
      assert %{a: "1", b: "2"} = load(path, LF)
    end
  end

  defp load(path, schema) do
    hd(EctoCSV.Loader.load(path, schema) |> Enum.take(1))
  end
end
