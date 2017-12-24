defmodule DataConv.Mixfile do
  use Mix.Project

  def project do
    [
      app: :data_conv,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      escript: [main_module: DataConv.CLI],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:csv, "~> 2.0"}
    ]
  end
end
