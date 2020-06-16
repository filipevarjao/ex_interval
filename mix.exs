defmodule ExInterval.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_interval,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers() ++ [:ex_interval],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      description: "Interval type and functions for Maximum Accuracy Interval Arithmetic",
      package: package(),
      source_url: "https://github.com/filipevarjao/ex_interval"
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["MIT License"],
      links: %{
        "GitHub" => "https://github.com/filipevarjao/ex_interval"
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:excoveralls, "~> 0.9", only: :test},
      {:ex_doc, "~> 0.22.1", only: :dev, runtime: false}
    ]
  end
end

defmodule Mix.Tasks.Compile.ExInterval do
  use Mix.Task.Compiler

  def run(_args) do
    System.cmd("make", [])
    :ok
  end
end
