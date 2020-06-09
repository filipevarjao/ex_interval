# ExInterval

ExInterval implements the interval type and range operations on the type, with rounded
directed intervals, recognize the input as strings and performs operations
between intervals.

Using intervals for the representation of real numbers, it is possible to
control the error propagation of rounding or truncation, between others, in 
numerical computational procedures.

[1] Moore, R. E., Interval Analysis. Prentice-Hall, Englewood Cliffs, New Jersey, 1966.

[2] Moore, R. E., Methods and Applications of Interval Analysis. SIAM Studies in Applied Mathematics, Philadelphia, 1979.

[3] Kulisch, U. W., Miranker, W. L., Computer Arithmetic in Theory and Practice. Academic Press, 1981.

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

*_It does not guarantee is preemption safe_
