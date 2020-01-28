module ImplicitPlots

export implicit_plot, implicit_plot!, implicit_curve!, implicit_surface!

import AbstractPlotting
import ColorSchemes, Contour
import GeometryTypes, Meshing
import Plots

import MultivariatePolynomials, StaticPolynomials
import StaticArrays: SVector
const MP = MultivariatePolynomials
const SP = StaticPolynomials

using DynamicPolynomials: @polyvar
export @polyvar

make_function(f::MP.AbstractPolynomialLike) = make_function(SP.Polynomial(f))
function make_function(f::SP.Polynomial)
    if SP.nvariables(f) == 2
        (x,y) -> f(SVector(x, y))
    elseif SP.nvariables(f) == 3
        (x, y, z) -> f(SVector(x, y, z))
    else
        throw(ArgumentError("Given polynomial is not in 2 or 3 variables."))
    end
end
make_function(f) = f

nvariables(f::MP.AbstractPolynomialLike) = MP.nvariables(f)
nvariables(f::SP.Polynomial) = SP.nvariables(f)
function nvariables(f::Function)
    nargs = 0
    try
        f(1.0, 1.0)
        nargs = 2
    catch e
        try
            f(1.0, 1.0, 1.0)
            nargs = 3
        catch e
            throw(ArgumentError("Provided function does not accept 2 or 3 arguments."))
        end
    end
    nargs
end

"""
    implicit_plot(f)

Visualize the implicit curve or surface `f(x,y, [z]) = 0`. `f` is either a function or
a polynomial following the `MultivariatePolynomials` package.

If `f` is a curve `Plots` is used, otherwise `AbstractPlotting`.

## Examples

Curve:
```
f(x,y) = (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y

implicit_plot(f; xlims=(-2,2), ylims=(-2,2))
```

Surface:
```
using Makie
g(x,z,y) = (0.3*x^2+0.5z-0.3x+1.2*y^2-1.1)^2+(0.7*(y+0.5x)^2+y+1.2*z^2-1)^2-0.3
implicit_plot(g; xlims=(-2,2), ylims=(-2,2), zlims=(-3,3))
```
"""
implicit_plot(f; kwargs...) = implicit_plot(f, Val(nvariables(f)); kwargs...)

"""
    implicit_plot!([plot], f)

Visualize `f` into the given `plot`. See also [implicit_plot](@ref).
"""
implicit_plot!(f; kwargs...) = implicit_plot!(nothing, f, Val(nvariables(f)); kwargs...)
implicit_plot!(p, f; kwargs...) = implicit_plot!(p, f, Val(nvariables(f)); kwargs...)

include("2d.jl")
include("3d.jl")

end # module
