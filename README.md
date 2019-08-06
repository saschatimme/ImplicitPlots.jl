# ImplicitPlots

[![Build Status](https://travis-ci.com/saschatimme/ImplicitPlots.jl.svg?branch=master)](https://travis-ci.com/saschatimme/ImplicitPlots.jl)


```julia
using ImplicitPlots
using DynamicPolynomials # input
using Makie # GLMakie backend

@polyvar x y
f =  (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y
plot(f)
```
