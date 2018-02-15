defmodule EctoCSV.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ecto_csv,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
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
      {:credo,           "~> 0.9.0-rc3", only: [:dev, :test], runtime: false},
      {:csv,             "~> 2.0"},
      {:ecto,            "~> 2.1"},
      {:mix_test_watch,  "~> 0.5", only: :dev},
      {:nimble_csv,      "~> 0.3"},
      {:excoveralls,     "~> 0.8", only: :test},
    ]
  end
end
