defmodule ScotiaBank.MortgageRetention do
  use CSV.Schema
  use CSV.Transforms

  column "Name", transform: &(downcase(&1) |> upcase)
  column  "Age", type: Integer
  column  "DOB", type: Date, format: "{YYYY}-{0M}-{0D}"
end  
