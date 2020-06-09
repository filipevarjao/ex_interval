defmodule ExInterval.Interval do
  @moduledoc """
  It implements the interval type and range operations on the type, using
  directed roundings intervals, recognize the input as strings and performs
  operations between intervals.
  """

  defstruct inf: nil, sup: nil

  @type t :: %__MODULE__{inf: Float, sup: Float}

  alias ExInterval.{Interval, Rounding}

  @doc """
  Returns a new Interval

  ## Parameters

   - new/1 or new/2

  ## Examples

    iex> ExInterval.Interval.new(1.1)
    [1.1, 1.1]

    iex> ExInterval.Interval.new(1.1, 2.5)
    [1.1, 2.5]
  """
  @spec new(number() | binary(), number() | binary()) :: list()
  def new([value1, value2]), do: new(value1, value2)

  def new(value) do
    real_number = cast_to_float(value)
    [real_number, real_number]
  end

  def new(value1, value2) do
    value1 = cast_to_float(value1)
    value2 = cast_to_float(value2)
    [min(value1, value2), max(value1, value2)]
  end

  @doc """
  Returns the middle point of the interval

  ## Parameters

   - middle/1

  ## Examples

    iex> ExInterval.Interval.middle(%ExInterval.Interval{inf: -10.0, sup: 5.0})
    -2.5
  """
  @spec middle(Interval.t() | list()) :: float()
  def middle(%Interval{inf: inf, sup: sup}) do
    backup_mode = Rounding.get_mode()
    Rounding.set_mode(1)
    mid = (inf + sup) / 2.0
    Rounding.set_mode(backup_mode)
    mid
  end

  def middle([inf, sup]), do: middle(%Interval{inf: inf, sup: sup})

  @doc """
  Returns true if the value is an element or a subset of the interval

  ## Parameters

   - is_member?/2

  ## Examples

    iex> ExInterval.Interval.is_member?(0.0, %ExInterval.Interval{inf: -1, sup: -0.1})
    false

    iex> ExInterval.Interval.is_member?(0.0, %ExInterval.Interval{inf: -1, sup: 1})
    true

    iex> ExInterval.Interval.is_member?(0.0, %ExInterval.Interval{inf: 0.1, sup: 1})
    false
  """
  @spec is_member?(
          number() | binary() | Interval.t(),
          number() | binary() | list() | Interval.t()
        ) ::
          boolean()
  def is_member?(value, [inf, sup]), do: is_member?(value, %Interval{inf: inf, sup: sup})

  def is_member?(first, second) do
    [first, second] = operators(first, second)
    contains(first, second)
  end

  @doc """
  Binary plus operator

  ## Parameters

   - add/2

  ## Examples

    iex> ExInterval.Interval.add(%ExInterval.Interval{inf: 0.25, sup: 0.5}, 2)
    [2.25, 2.5]

    iex> ExInterval.Interval.add("0.1", 0.1)
    [0.2, 0.2]
  """
  @spec add(
          number() | binary() | Interval.t() | list(),
          number() | binary() | Interval.t() | list()
        ) ::
          list()
  def add([val1, val2], [val3, val4]),
    do: add(%Interval{inf: val1, sup: val2}, %Interval{inf: val3, sup: val4})

  def add(first, second) do
    [first, second] = operators(first, second)
    plus(first, second)
  end

  @doc """
  Binary minus operator

  ## Parameters

   - sub/2

  ## Examples

    iex> ExInterval.Interval.sub(%ExInterval.Interval{inf: 0.25, sup: 0.5}, 2)
    [-1.75, -1.5]

    iex> ExInterval.Interval.sub(%ExInterval.Interval{inf: -0.75, sup: 0.75}, "2")
    [-2.75, -1.25]

    iex> ExInterval.Interval.sub("0.1", 0.1)
    [0.0, 0.0]
  """
  @spec sub(
          number() | binary() | Interval.t() | list(),
          number() | binary() | Interval.t() | list()
        ) ::
          list()
  def sub([val1, val2], [val3, val4]),
    do: sub(%Interval{inf: val1, sup: val2}, %Interval{inf: val3, sup: val4})

  def sub(first, second) do
    [first, second] = operators(first, second)
    minus(first, second)
  end

  @doc """
  Multiplication operator

  ## Parameters

   - mul/2

  ## Examples

    iex> ExInterval.Interval.mul(%ExInterval.Interval{inf: 0.25, sup: 0.5}, %ExInterval.Interval{inf: 2.0, sup: 3.0})
    [0.5, 1.5]

    iex> ExInterval.Interval.mul(%ExInterval.Interval{inf: -0.75, sup: 0.75}, "2")
    [-1.5, 1.5]

    iex> ExInterval.Interval.mul(0.2, "0.1")
    [0.02, 0.020000000000000004]
  """
  @spec mul(
          number() | binary() | Interval.t() | list(),
          number() | binary() | Interval.t() | list()
        ) ::
          list()
  def mul([val1, val2], [val3, val4]),
    do: mul(%Interval{inf: val1, sup: val2}, %Interval{inf: val3, sup: val4})

  def mul(first, second) do
    [first, second] = operators(first, second)
    multiplication(first, second)
  end

  @doc """
  Division operator

  ## Parameters

   - div/2

  ## Examples

    iex> ExInterval.Interval.division(%ExInterval.Interval{inf: 0.25, sup: 0.5}, %ExInterval.Interval{inf: 2, sup: 4})
    [0.0625, 0.25]

    iex> ExInterval.Interval.division(%ExInterval.Interval{inf: -0.75, sup: 0.75}, 2)
    [-0.375, 0.375]

    iex> ExInterval.Interval.division("0.1", 0.1)
    [1.0, 1.0]
  """
  @spec division(
          number() | binary() | Interval.t() | list(),
          number() | binary() | Interval.t() | list()
        ) ::
          list()
  def division([val1, val2], [val3, val4]),
    do: div_int(%Interval{inf: val1, sup: val2}, %Interval{inf: val3, sup: val4})

  def division(first, second) do
    [first, second] = operators(first, second)
    div_int(first, second)
  end

  @doc """
  Calculates the machine epsilon

  ## Parameters

  - eps/0

  ##

  iex> ExInterval.Interval.eps
  2.220446049250313e-16
  """
  @spec eps() :: number
  def eps, do: calculate_epsilon(1)

  defp calculate_epsilon(macheps) do
    case 1.0 + macheps / 2 > 1.0 do
      true -> calculate_epsilon(macheps / 2)
      false -> macheps
    end
  end

  defp contains(%Interval{inf: x2, sup: y2}, %Interval{inf: x1, sup: y1}) do
    x1 <= x2 and y1 >= y2
  end

  defp operators(%Interval{} = first, %Interval{} = second), do: [first, second]
  defp operators(%Interval{} = first, second), do: [first, create_interval(second)]
  defp operators(first, %Interval{} = second), do: [create_interval(first), second]
  defp operators(first, second), do: [create_interval(first), create_interval(second)]

  defp create_interval(value) do
    real_number = cast_to_float(value)
    %Interval{inf: real_number, sup: real_number}
  end

  defp div_int(%Interval{inf: x1, sup: y1}, %Interval{inf: x2, sup: y2}) do
    backup_mode = Rounding.get_mode()
    Rounding.set_mode(-1)
    inf = min(min(x1 / x2, x1 / y2), min(y1 / x2, y1 / y2))
    Rounding.set_mode(1)
    sup = max(max(x1 / x2, x1 / y2), max(y1 / x2, y1 / y2))
    Rounding.set_mode(backup_mode)
    new(inf, sup)
  end

  defp multiplication(%Interval{inf: x1, sup: y1}, %Interval{inf: x2, sup: y2}) do
    backup_mode = Rounding.get_mode()
    Rounding.set_mode(-1)
    inf = min(min(x1 * x2, x1 * y2), min(y1 * x2, y1 * y2))
    Rounding.set_mode(1)
    sup = max(max(x1 * x2, x1 * y2), max(y1 * x2, y1 * y2))
    Rounding.set_mode(backup_mode)
    new(inf, sup)
  end

  defp minus(%Interval{} = first, %Interval{} = second) do
    backup_mode = Rounding.get_mode()
    Rounding.set_mode(-1)
    inf = first.inf - second.inf
    Rounding.set_mode(1)
    sup = first.sup - second.sup
    Rounding.set_mode(backup_mode)
    new(inf, sup)
  end

  defp plus(%Interval{} = first, %Interval{} = second) do
    backup_mode = Rounding.get_mode()
    Rounding.set_mode(-1)
    inf = first.inf + second.inf
    Rounding.set_mode(1)
    sup = first.sup + second.sup
    Rounding.set_mode(backup_mode)
    new(inf, sup)
  end

  defp cast_to_float(value) when is_float(value), do: value

  defp cast_to_float(value) when is_integer(value) or is_binary(value) do
    Float.parse("#{value}")
    |> Kernel.elem(0)
  end
end
