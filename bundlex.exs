defmodule ExInterval.BundlexProject do
  use Bundlex.Project

  def project() do
    [
      nifs: nifs(Bundlex.platform),
      cnodes: [],
      libs: [],
      ports: []
    ]
  end

  defp nifs(_platform) do
    [
      rounding: [
        sources: ["rounding.c"]
      ]
    ]
  end
end
