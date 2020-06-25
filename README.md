# ExInterval

ExInterval implements the interval type and range operations on the type, with rounded
directed intervals, recognize the input as strings and performs operations
between intervals.

Using intervals for the representation of real numbers, it is possible to
control the error propagation of rounding or truncation, between others, in 
numerical computational procedures.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_interval` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_interval, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_interval](https://hexdocs.pm/ex_interval).

<<<<<<< Updated upstream
## Dependencies
The header **<fenv.h>** supports the intended model of use for the floating-point
environment. It was defined in C99, and describe the handling of floating-point
rounding and exceptions (overflow, zero-divide, etc.).

=======
>>>>>>> Stashed changes
## Interval
It implements the interval type.
```
iex> Interval.new(1.1)
[1.1, 1.1]
iex> Interval.new(-1, "0.1")  # recognize the input as strings too
[-1.0, 0.1]

```

## Interval operations
The operations of interval follow the interval arithmetic with maximum accuracy
that captures essential properties associated with rounding.

### Binary plus operator
```
iex> Interval.add("0.1", 0.1)
[0.2, 0.2]
iex> Interval.add([0.25, 0.5], [2.0, 2.0])
[2.25, 2.5]
```
Similarly, it provides minus (**sub**), multiplication (**mul**), and division (**division**) operators.

## Helpers
eps/0, is_member?/2, middle/1, absolute/1, diameter/1
```
iex> eps = Interval.eps
2.220446049250313e-16
iex> Interval.is_member?(eps, [0.0, 0.1])                                  
true
iex> Interval.middle([0.0, 0.1])
0.05
iex> Interval.absolute([-1, 1])
1.0
iex> Interval.diameter([0.0, 0.1])
0.1
```
## Rounding
The error control is done by directed rounding for the interval operations, we also
can use Rounding helper functions.
```
iex> backup_mode = Rounding.get_mode()
0
iex> Rounding.set_mode(-1)
0
iex> 1/3                             
0.3333333333333333
iex> Rounding.set_mode(1) 
0
iex> 1/3                             
0.33333333333333337
iex> Rounding.set_mode(backup_mode)
0
```
*_It does not guarantee is preemption safe_.
## References

[1] Moore, R. E., Interval Analysis. Prentice-Hall, Englewood Cliffs, New Jersey, 1966.

[2] Moore, R. E., Methods and Applications of Interval Analysis. SIAM Studies in Applied Mathematics, Philadelphia, 1979.

[3] Kulisch, U. W., Miranker, W. L., Computer Arithmetic in Theory and Practice. Academic Press, 1981.
