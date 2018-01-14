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
      {:briefly,         "~> 0.3", only: :test},
      {:ecto,            "~> 2.1"},
      {:mix_test_watch,  "~> 0.5", only: :dev},
      {:nimble_csv,      "~> 0.3"},
      {:postgrex,        ">= 0.0.0"},
      {:timex,           "~> 3.0"},
    ]
  end
end
