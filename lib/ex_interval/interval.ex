defmodule ExInterval.Interval do
  defstruct inf: nil, sup: nil

  @type t :: %__MODULE__{inf: Float, sup: Float}
end
