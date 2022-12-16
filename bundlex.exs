defmodule ExInterval.BundlexProject do
  use Bundlex.Project

  def project() do
    [
      natives: natives(Bundlex.platform()),
      libs: libs(),
    ]
  end

  defp natives(_platform) do
    [
      rounding: [
        sources: ["rounding.c"],
        interface: :nif,
        compiler_flags: ["-Wno-missing-field-initializers"]
      ]
    ]
  end

  defp libs() do
    []
  end

end
