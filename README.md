# ImplicitPlots

[![Build Status](https://travis-ci.com/saschatimme/ImplicitPlots.jl.svg?branch=master)](https://travis-ci.com/saschatimme/ImplicitPlots.jl)

Plots curves and surfaces defined by a polynomial `f(x,y)=0` resp. `f(x,y,z)=0`.

## Plane curves

```julia
using ImplicitPlots

f(x,y) = (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y
implicit_plot(f; xlims=(-2,2), ylims=(-2,2))
```
<img src="images/example_curve.png" style="max-width:100%" width="400px"></img>

Polynomials following the MultivariatePolynomials.jl interface are also supported.
For convenience also the `@polyvar` macro from DynamicPolynomials.jl is exported.
```julia
@polyvar x y
f2 = (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y
implicit_plot(f2; xlims=(-2,2), ylims=(-2,2))
```

## Surface

For surfaces you need to have a backend for `AbstractPlotting` installed.
```julia
using ImplicitPlots
using Makie # GLMakie backend for AbstractPlotting

@polyvar x y z
g = (0.3*x^2+0.5z-0.3x+1.2*y^2-1.1)^2+(0.7*(y+0.5x)^2+y+1.2*z^2-1)^2-0.3
implicit_plot(g)
```
