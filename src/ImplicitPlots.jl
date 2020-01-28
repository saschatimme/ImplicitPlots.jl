module ImplicitPlots

export implicit_plot

import ColorSchemes, Contour
import GeometryTypes, Meshing
import Plots

import MultivariatePolynomials, StaticPolynomials
import StaticArrays: SVector
const MP = MultivariatePolynomials
const SP = StaticPolynomials

using Requires: @require
using DynamicPolynomials: @polyvar
export @polyvar

function __init__()
    @require AbstractPlotting = "537997a7-5e4e-5d89-9595-2241ea00577e" include("3d.jl")
end

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

implicit_plot(f; kwargs...) = implicit_plot(f, Val(nvariables(f)); kwargs...)
implicit_plot!(f; kwargs...) = implicit_plot!(nothing, f, Val(nvariables(f)); kwargs...)
implicit_plot!(p, f; kwargs...) = implicit_plot!(p, f, Val(nvariables(f)); kwargs...)


function implicit_plot(
    f,
    nargs::Val{2};
    aspect_ratio = :equal,
    size = (800, 800),
    kwargs...,
)
    p = Plots.plot(; aspect_ratio = aspect_ratio, size = size)
    implicit_curve!(p, f; kwargs...)
end
implicit_plot!(p, f, nargs::Val{2}; kwargs...) = implicit_curve!(p, f; kwargs...)

"""
    implicit_curve(f; x_min=-5, x_max=5, y_min=x_min, y_max=x_max,
                      color_curvature=false, color=:steelblue, resolution=1000)
Visualize the implicit curve `f` in the box `[x_min, x_max] × [y_min, y_max]`.
If `color_curvature` is `true` then the curve is locally colored depending on its curvature.
Otherwise `color` is used.
"""
function implicit_curve!(
    p,
    f;
    x_min = -3.0,
    xmin = x_min,
    x_max = 3.0,
    xmax = x_max,
    y_min = x_min,
    ymin = y_min,
    y_max = x_max,
    ymax = y_max,
    xlims = (xmin, xmax),
    ylims = (ymin, ymax),
    color_curvature = false,
    color = :steelblue,
    resolution = 1000,
    linewidth = 2,
    grid = true,
    legend = false,
    kwargs...,
)
    g = make_function(f)
    rx = range(xlims...; length = resolution)
    ry = range(ylims...; length = resolution)
    z = [g(x, y) for x in rx, y in ry]

    lvl = Contour.contour(collect(rx), collect(ry), z, 0.0)
    lines = Contour.lines(lvl)
    !isempty(lines) || return p

    for l in lines
        xs, ys = Contour.coordinates(l)

        if p === nothing
            Plots.plot!(
                xs,
                ys;
                xlims = xlims,
                ylims = ylims,
                color = color,
                legend = legend,
                linewidth = linewidth,
                kwargs...,
            )
        else
            Plots.plot!(
                p,
                xs,
                ys;
                xlims = xlims,
                ylims = ylims,
                color = color,
                legend = legend,
                linewidth = linewidth,
                kwargs...,
            )
        end
    end

    p
end

end # module
