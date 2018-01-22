includes = []
excludes = [:skip]

# Uncomment the line below to enable focus mode
# includes = [:focus | includes]; excludes = [:test | excludes]

ExUnit.start(include: includes, exclude: excludes)

defmodule TestFile do 
  def create(content \\ "") do
    path = Briefly.create!
    File.write!(path, content)
    path
  end

  def create_pair(content \\ "") do
    {create(content), create()}
  end
end