defmodule ExInterval.Rounding do
  @moduledoc """
  Rounding is a NIF module, allowing us to get or modify the floating-point
  status flags affecting the outcomes of some floating-point operations.
  """
  use Bundlex.Loader, nif: :rounding

  @doc """
  Gets the status of the floating-point environment

  ## Parameters

    - get/0

  ## Examples

    iex> ExInterval.Rounding.get_mode()
    0
  """
  defnif(get_mode())

  defnif(set_mode_to_nearest())
  defnif(set_mode_downward())
  defnif(set_mode_upward())
  defnif(set_mode_toward_zero())
  defnif(restore_mode(mode))
end
