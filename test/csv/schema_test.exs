defmodule CSV.SchemaTest do
  use ExUnit.Case

  defmodule Example do
    use CSV.Schema

    schema "test" do
      field :a
      field :b
      field :c
    end

    csv do end
  end

  describe "with empty csv block" do
    test "'file_has_header?'' should be 'true'" do
      assert Example.__csv__(:file_has_header?) == true
    end  

    test "'header' should be 'true'" do
      assert Example.__csv__(:file_has_header?) == true
    end  

    test "'headers' should be set from fields'" do
      assert Example.__csv__(:headers) == [:a, :b, :c]
    end  
  end
end
