defmodule MyApp.BundlexProject do
  use Bundlex.Project

  def project() do
    [
      nifs: nifs(Bundlex.platform()),
      cnodes: cnodes(),
      libs: libs(),
      ports: ports()
    ]
  end

  #  defp nifs(:linux) do
  #    [
  #      rounding: [
  #        sources: ["rounding.c"]
  #      ]
  #    ]
  #  end

  defp nifs(_platform) do
    [
      rounding: [
        sources: ["rounding.c"]
      ]
    ]
  end

  defp cnodes() do
    []
  end

  defp ports() do
    []
  end

  defp libs() do
    []
  end
end
