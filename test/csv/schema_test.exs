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

  defmodule Example2 do
    use CSV.Schema

    schema "test" do
      field :a
      field :b
      field :c
    end

    csv do
      header true
    end
  end

  describe "with header set to 'true'" do
    test "'file_has_header?'' should be 'true'" do
      assert Example2.__csv__(:file_has_header?) == true
    end  

    test "'header' should be 'true'" do
      assert Example2.__csv__(:file_has_header?) == true
    end  

    test "'headers' should be set from fields'" do
      assert Example2.__csv__(:headers) == [:a, :b, :c]
    end  
  end

  defmodule Example3 do
    use CSV.Schema

    schema "test" do
      field :a
      field :b
      field :c
    end

    csv do
      header false
    end
  end

  describe "with header set to 'false'" do
    test "'file_has_header?'' should be 'false'" do
      assert Example3.__csv__(:file_has_header?) == false
    end  

    test "'header' should be 'false'" do
      assert Example3.__csv__(:file_has_header?) == false
    end  

    test "'headers' should be set from fields'" do
      assert Example3.__csv__(:headers) == [:a, :b, :c]
    end  
  end
end
