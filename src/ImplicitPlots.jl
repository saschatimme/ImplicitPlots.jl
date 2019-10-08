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

"""
    compute_z(f, rx, ry)
Compute all values ``f(x,y)`` for ``(x,y) ∈ rx × ry``.
"""
compute_z(f::MP.AbstractPolynomialLike, rx, ry) = compute_z(SP.Polynomial(f), rx, ry)
compute_z(f::SP.Polynomial, rx, ry) = [f(SVector(x, y)) for x in rx, y in ry]
compute_z(f::Function, rx, ry) = [f(x, y) for x in rx, y in ry]

function implicit_plot(f::MP.AbstractPolynomialLike; kwargs...)
    implicit_plot(f, Val(MP.nvariables(f)); kwargs...)
end

function implicit_plot(
    f::MP.AbstractPolynomialLike,
    ::Val{2};
    aspect_ratio = :equal,
    size = (600, 600),
    kwargs...,
)
    # scene = AbstractPlotting.Scene(resolution = scene_resolution, scale_plot = false)
    p = Plots.plot(; aspect_ratio = aspect_ratio, size = size)
    implicit_plot!(p, f; kwargs...)
end

function implicit_plot!(scene, f::MP.AbstractPolynomialLike; wireframe = nothing, kwargs...)
    if MP.nvariables(f) == 2
        implicit_curve!(scene, f; kwargs...)
    else
        implicit_surface!(scene, f; wireframe = wireframe, kwargs...)
    end
end

"""
    implicit_curve(f; x_min=-5, x_max=5, y_min=x_min, y_max=x_max,
                      color_curvature=false, color=:steelblue, resolution=1000)
Visualize the implicit curve `f` in the box `[x_min, x_max] × [y_min, y_max]`.
If `color_curvature` is `true` then the curve is locally colored depending on its curvature.
Otherwise `color` is used.
"""
function implicit_curve!(
    p,
    f::MP.AbstractPolynomialLike;
    x_min = -3.0,
    x_max = 3.0,
    y_min = x_min,
    y_max = x_max,
    xlims = (x_min, x_max),
    ylims = (y_min, y_max),
    color_curvature = false,
    color = :steelblue,
    resolution = 1000,
    linewidth = 2,
    grid = true,
    legend = false,
    kwargs...,
)
    g = SP.Polynomial(f)
    x = collect(range(xlims...; length = resolution))
    y = collect(range(ylims...; length = resolution))
    z = compute_z(f, x, y)


    # limits = AbstractPlotting.FRect(x_min, y_min, x_max - x_min, y_max - y_min)
    lvl = Contour.contour(x, y, z, 0.0)
    lines = Contour.lines(lvl)
    !isempty(lines) || return scene
    for l in lines
        xs, ys = Contour.coordinates(l)

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

    p
end

end # module
