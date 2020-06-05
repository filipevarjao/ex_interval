defmodule ExInterval.Rounding do
  @on_load :load_nifs

  def load_nifs, do: :erlang.load_nif('./rounding', 0)

  def init, do: :erlang.load_nif('./rounding', 0)

  def get_mode, do: raise("NIF get_mode/0 not implemented")

  def set_mode(_), do: raise("NIF set_mode/0 not implemented")
end
