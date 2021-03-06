defmodule ExInterval.IntervalTest do
  use ExUnit.Case
  doctest ExInterval.Interval

  alias ExInterval.Rounding

  test "running benchmark" do
    matrix_a = generate_matrix()
    matrix_b = generate_matrix()

    p1 = Task.async(fn -> benchmark({matrix_a, matrix_b}, :round_off) end)
    p2 = Task.async(fn -> benchmark({matrix_a, matrix_b}, :round_down) end)
    p3 = Task.async(fn -> benchmark({matrix_a, matrix_b}, :round_up) end)

    m1 = Task.await(p1)
    m2 = Task.await(p2)
    m3 = Task.await(p3)

    assert m1 >= m2
    assert m2 < m3
  end

  def benchmark({matrix_a, matrix_b}, mode) do
    backup_mode = Rounding.get_mode()
    true = :erlang.yield()

    case mode do
      :round_down ->
        Rounding.set_mode_downward()

      :round_up ->
        Rounding.set_mode_upward()

      _ ->
        Rounding.set_mode_to_nearest()
    end

    true = :erlang.yield()
    new_b = transpose(matrix_b)

    result =
      Enum.map(matrix_a, fn row ->
        Enum.map(new_b, &dot_product(row, &1))
      end)
      |> Enum.flat_map(& &1)
      |> Enum.sum()

    Rounding.restore_mode(backup_mode)
    result
  end

  def generate_matrix do
    Enum.map(:lists.seq(0, 9), fn _ ->
      :lists.seq(0, 9)
      |> Enum.map(fn _ -> :random.uniform() end)
    end)
  end

  def dot_product(row_a, row_b) do
    Stream.zip(row_a, row_b)
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  def transpose(cells), do: transposed(cells)

  defp transposed([[] | _]), do: []

  defp transposed(cells) do
    [Enum.map(cells, fn x -> hd(x) end) | transposed(Enum.map(cells, fn x -> tl(x) end))]
  end
end
