# ImplicitPlots

[![Build Status](https://travis-ci.com/saschatimme/ImplicitPlots.jl.svg?branch=master)](https://travis-ci.com/saschatimme/ImplicitPlots.jl)

Plots curves and surfaces defined by a polynomial `f(x,y)=0` resp. `f(x,y,z)=0`.

## Curve in the plane
```julia
using ImplicitPlots
using DynamicPolynomials # input
using Makie # GLMakie backend

@polyvar x y
f =  (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y
implicit_plot(f)
```

## Surface
```julia
using ImplicitPlots
using DynamicPolynomials # input
using Makie # GLMakie backend

@polyvar x y z
g = (0.3*x^2+0.5z-0.3x+1.2*y^2-1.1)^2+(0.7*(y+0.5x)^2+y+1.2*z^2-1)^2-0.3
implicit_plot(g)
```
