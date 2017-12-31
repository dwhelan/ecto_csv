
defprotocol Cell do
  def parse(string)
end

defmodule Test do
  # use Inbox.CSV
  require Timex

  def columns, do: [
    member_id:       "Member_id",
    email:           "Email_address",
    first_name:      "First_Name",
    language_code:   "Lang_code",
    campaign_code:   "Campaign Code",
    cell_id:         "Cell Id", 
    cell_start_date:  { "Cell Start Date", &(date(&1, "{YYYY}{0M}{0D}")) },
    cell_start_date:  { "Cell Start Date", &(Timex.parse(&1, "{YYYY}{0M}{0D}")) },
    cell_start_date:  { "Cell Start Date", fn cell -> date(cell, "{YYYY}{0M}{0D}") end },
    cell_start_date:  { "Cell Start Date", fn cell -> Timex.parse(cell, "{YYYY}{0M}{0D}") end },
    cell_start_date:  { "Cell Start Date", :date, "{YYYY}{0M}{0D}" },
  ]
  
  def date(cell, format) do
    Timex.parse(cell, format)
  end

  # Member_id|Email_address|First_Name|Lang_code|Campaign Code|Cell Id|Cell Start Date|Offer Expiry Date|Business Name|Credit Limit|Mail_ID|A|B|C|D|E|F|G|H|I|J|K|L|
end
