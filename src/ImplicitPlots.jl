module ImplicitPlots

export plot

import AbstractPlotting
import ColorSchemes, Contour
import GeometryTypes, Meshing

import MultivariatePolynomials, StaticPolynomials
import StaticArrays: SVector
const MP = MultivariatePolynomials
const SP = StaticPolynomials

# import ColorSchemes, Contour
# import DynamicPolynomials, HomotopyContinuation, StaticPolynomials
# import StaticArrays: SVector
# const DP = DynamicPolynomials
# const HC = HomotopyContinuation
# const SP = StaticPolynomials
# using LinearAlgebra
# using Makie, GeometryTypes, Meshing

"""
    compute_z(f, rx, ry)
Compute all values ``f(x,y)`` for ``(x,y) ∈ rx × ry``.
"""
compute_z(f::MP.AbstractPolynomialLike, rx, ry) = compute_z(SP.Polynomial(f), rx, ry)
compute_z(f::SP.Polynomial, rx, ry) = [f(SVector(x,y)) for x in rx, y in ry]
compute_z(f::Function, rx, ry) = [f(x,y) for x in rx, y in ry]


function plot(f::MP.AbstractPolynomialLike; scene_resolution=(1000,1000), kwargs...)
    scene = AbstractPlotting.Scene(resolution=scene_resolution, scale_plot=false)
    plot!(scene, f; kwargs...)
end
function plot!(scene, f::MP.AbstractPolynomialLike; wireframe=nothing, kwargs...)
    if MP.nvariables(f) == 2
        implicit_curve!(scene, f; kwargs...)
    else
        implicit_surface!(scene, f; wireframe=wireframe, kwargs...)
    end
end

"""
    implicit_curve!(scene, f; x_min=-5, x_max=5, y_min=x_min, y_max=x_max,
                      color_curvature=false, color=:steelblue, resolution=1000)
Visualize the implicit curve `f` in the box `[x_min, x_max] × [y_min, y_max]`.
If `color_curvature` is `true` then the curve is locally colored depending on its curvature.
Otherwise `color` is used.
"""
function implicit_curve!(scene, f::MP.AbstractPolynomialLike; x_min=-3., x_max=3., y_min=x_min, y_max=x_max,
            color_curvature=false, color=:steelblue, resolution=1000, grid=true, kwargs...)
    g = SP.Polynomial(f)
    x = collect(range(x_min, x_max; length=resolution))
    y = collect(range(y_min, y_max; length=resolution))
    z = compute_z(f, x, y)

    limits = AbstractPlotting.FRect(x_min, y_min, x_max - x_min, y_max - y_min)
    lvl = Contour.contour(x, y, z, 0.0)
    lines = Contour.lines(lvl)
    !isempty(lines) || return scene
    for l in lines
        xs, ys = Contour.coordinates(l)
        AbstractPlotting.lines!(scene, xs, ys; linewidth=3,
        color=color, limits=limits, kwargs...)
    end

    axis = scene[AbstractPlotting.Axis] # get the axis object from the scene
    if !isnothing(axis)
        if grid == false
            axis[:grid][:linewidth] = (0,0)
        end
        axis[:ticks][:textsize] = (2, 2)
        axis[:ticks][:textsize] = (2, 2)
        axis[:names][:textsize] = (2, 2)
    end
    scene
end

"""
    implicit_surface!(scene, f; x_min=-3, x_max=3, y_min=x_min, y_max=x_max, z_min=x_min, z_max=z_max,
                      color_curvature=false, color=:steelblue, resolution=1000)
Visualize the implicit curve `f` in the box `[x_min, x_max] × [y_min, y_max]`.
If `color_curvature` is `true` then the curve is locally colored depending on its curvature.
Otherwise `color` is used.
"""
function implicit_surface!(scene, f::MP.AbstractPolynomialLike; x_min=-3., x_max=3., y_min=x_min, y_max=x_max,
                z_min=x_min, z_max=x_max, color=:steelblue,
                show_axis=true,
                wireframe=false,
                mesh_resolution=0.04, grid=true, kwargs...)
    g = SP.Polynomial(f)
    box = GeometryTypes.HyperRectangle(AbstractPlotting.Vec(x_min,y_min, float(z_min)),
            AbstractPlotting.Vec(float(x_max-x_min),y_max-y_min,z_max-z_min))
    sdf = Meshing.SignedDistanceField(v -> g(v), box, mesh_resolution)
    m = Meshing.GLNormalMesh(sdf, Meshing.MarchingTetrahedra())
    if isnothing(wireframe) || !wireframe
        AbstractPlotting.mesh!(scene, m, show_axis=show_axis, color=color, kwargs...)
    else
        AbstractPlotting.wireframe!(scene, m, show_axis=show_axis, kwargs...)
    end

    scene
end

end # module
