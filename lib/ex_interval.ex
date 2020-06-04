defmodule ExInterval do
  @moduledoc """
  It implements the interval type and range operations on the type, using
  directed roundings intervals, recognize the input as strings and performs
  operations between intervals.

  Using intervals for the representation of real numbers, it is possible to
  control the error propagation of rounding or truncation, between others, in
  numerical computational procedures.

  [1] Moore, R. E., Interval Analysis. Prentice-Hall, Englewood Cliffs, New
        Jersey, 1966.
  [2] Moore, R. E., Methods and Applications of Interval Analysis. SIAM
      Studies in Applied Mathematics, Philadelphia, 1979.
  [3] Kulisch, U. W., Miranker, W. L., Computer Arithmetic in Theory and
      Practice. Academic Press, 1981.
  """

  alias ExInterval.{Interval, Rounding}

  @doc """
  Returns a new Interval

  ## Parameters

   - new/1 or new/2

  ## Examples

    iex> ExInterval.new(1.1)
    [1.1, 1.1]

    iex> ExInterval.new(1.1, 2.5)
    [1.1, 2.5]
  """
  @spec new(number() | binary(), number() | binary()) :: List
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

    iex> ExInterval.middle(%ExInterval.Interval{inf: -10.0, sup: 5.0})
    -2.5
  """
  @spec middle(Interval.t()) :: Float
  def middle(%Interval{inf: inf, sup: sup}) do
    backup_mode = Rounding.get_mode()
    Rounding.set_mode(1)
    mid = (inf+sup)/2.0
    Rounding.set_mode(backup_mode)
    mid
  end

  @doc """
  Returns true if the value is an element or a subset of the interval

  ## Parameters

   - is_member?/2

  ## Examples

    iex> ExInterval.is_member?(0.0, %ExInterval.Interval{inf: -1, sup: -0.1})
    false

    iex> ExInterval.is_member?(0.0, %ExInterval.Interval{inf: -1, sup: 1})
    true

    iex> ExInterval.is_member?(0.0, %ExInterval.Interval{inf: 0.1, sup: 1})
    false
  """
  @spec is_member?(number() | binary() | Interval.t(), number() | binary() | Interval.t()) :: boolean()
  def is_member?(first, second) do
    [first, second] = operators(first, second)
    contains(first, second)
  end

  @doc """
  Binary plus operator

  ## Parameters

   - add/2

  ## Examples

    iex> ExInterval.add(%ExInterval.Interval{inf: 0.25, sup: 0.5}, 2)
    [2.25, 2.5]

    iex> ExInterval.add("0.1", 0.1)
    [0.2, 0.2]
  """
  @spec add(number() | binary() | Interval.t(), number() | binary() | Interval.t()) :: Interval.t()
  def add(first, second) do
    [first, second] = operators(first, second)
    plus(first, second)
  end

  @doc """
  Binary minus operator

  ## Parameters

   - sub/2

  ## Examples

    iex> ExInterval.sub(%ExInterval.Interval{inf: 0.25, sup: 0.5}, 2)
    [-1.75, -1.5]

    iex> ExInterval.sub(%ExInterval.Interval{inf: -0.75, sup: 0.75}, "2")
    [-2.75, -1.25]

    iex> ExInterval.sub("0.1", 0.1)
    [0.0, 0.0]
  """
  @spec sub(number() | binary() | Interval.t(), number() | binary() | Interval.t()) :: Interval.t()
  def sub(first, second) do
    [first, second] = operators(first, second)
    minus(first, second)
  end

  @doc """
  Multiplication operator

  ## Parameters

   - mul/2

  ## Examples

    iex> ExInterval.mul(%ExInterval.Interval{inf: 0.25, sup: 0.5}, %ExInterval.Interval{inf: 2.0, sup: 3.0})
    [0.5, 1.5]

    iex> ExInterval.mul(%ExInterval.Interval{inf: -0.75, sup: 0.75}, "2")
    [-1.5, 1.5]

    iex> ExInterval.mul(0.2, "0.1")
    [0.02, 0.020000000000000004]
  """
  @spec mul(number() | binary() | Interval.t(), number() | binary() | Interval.t()) :: Interval.t()
  def mul(first, second) do
    [first, second] = operators(first, second)
    multiplication(first, second)
  end

  @doc """
  Division operator

  ## Parameters

   - div/2

  ## Examples

    iex> ExInterval.div(%ExInterval.Interval{inf: 0.25, sup: 0.5}, %ExInterval.Interval{inf: 2, sup: 4})
    [0.0625, 0.25]

    iex> ExInterval.div(%ExInterval.Interval{inf: -0.75, sup: 0.75}, 2)
    [-0.375, 0.375]

    iex> ExInterval.div("0.1", 0.1)
    [1.0, 1.0]
  """
  @spec div(number() | binary() | Interval.t(), number() | binary() | Interval.t()) :: Interval.t()
  def div(first, second) do
    [first, second] = operators(first, second)
    division(first, second)
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

  defp division(%Interval{inf: x1, sup: y1}, %Interval{inf: x2, sup: y2}) do
    backup_mode = Rounding.get_mode()
    Rounding.set_mode(-1)
    inf = min(min(x1/x2, x1/y2), min(y1/x2, y1/y2))
    Rounding.set_mode(1)
    sup = max(max(x1/x2, x1/y2), max(y1/x2, y1/y2))
    Rounding.set_mode(backup_mode)
    new(inf, sup)
  end

  defp multiplication(%Interval{inf: x1, sup: y1}, %Interval{inf: x2, sup: y2}) do
    backup_mode = Rounding.get_mode()
    Rounding.set_mode(-1)
    inf = min(min(x1*x2, x1*y2), min(y1*x2, y1*y2))
    Rounding.set_mode(1)
    sup = max(max(x1*x2, x1*y2), max(y1*x2, y1*y2))
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
