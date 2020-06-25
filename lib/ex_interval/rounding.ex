defmodule ExInterval.Rounding do

   use Bundlex.Loader, nif: :rounding

  @moduledoc """
  Rounding is a NIF module, allowing us to get or modify the floating-point
  status flags affecting the outcomes of some floating-point operations.
  """


  @doc """
  Gets the status of the floating-point environment

  ## Parameters

    - get/0

  ## Examples

    iex> ExInterval.Rounding.get_mode()
    0
  """
  defnif(get_mode())

#  @doc """
#  Sets the status of the floating-point environment set_mode(0),set_mode(-1) or
#  set_mode(1)
#
#  ## Parameters
#
#    - set/1
#
#  ## Examples
#
#    iex> backup_mode = ExInterval.Rounding.get_mode()
#    0
#
#    iex> ExInterval.Rounding.set_mode(-1)
#    0
#
#    iex> 1/3
#    0.3333333333333333
#
#    iex> ExInterval.Rounding.set_mode(1)
#    0
#
#    iex> 1/3
#    0.33333333333333337
#
#    iex> ExInterval.Rounding.set_mode(backup_mode)
#    0
#  """
  defnif(set_mode_to_nearest())
  defnif(set_mode_downward())
  defnif(set_mode_upward())
  defnif(set_mode_toward_zero())
  defnif(restore_mode(mode))
end
