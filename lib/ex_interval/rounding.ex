defmodule ExInterval.Rounding do
  @moduledoc """
  Rounding is a NIF module, allowing us to get or modify the floating-point
  status flags affecting the outcomes of some floating-point operations.
  """
  @on_load :load_nifs

  def load_nifs, do: :erlang.load_nif('./rounding', 0)

  def init, do: :erlang.load_nif('./rounding', 0)

  @doc """
  Gets the status of the floating-point environment

  ## Parameters

    - get/0

  ## Examples

    iex> ExInterval.Rounding.get_mode()
    0
  """
  def get_mode, do: raise("NIF get_mode/0 not implemented")

  @doc """
  Sets the status of the floating-point environment set_mode(0),set_mode(-1) or
  set_mode(1)

  ## Parameters

    - set/1

  ## Examples

    iex> backup_mode = ExInterval.Rounding.get_mode()
    0

    iex> ExInterval.Rounding.set_mode(-1)
    0

    iex> 1/3
    0.3333333333333333

    iex> ExInterval.Rounding.set_mode(1)
    0

    iex> 1/3
    0.33333333333333337

    iex> ExInterval.Rounding.set_mode(backup_mode)
    0
  """
  def set_mode(_), do: raise("NIF set_mode/0 not implemented")
end
