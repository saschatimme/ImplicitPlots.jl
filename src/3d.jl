import .AbstractPlotting

function implicit_plot(
    f::MP.AbstractPolynomialLike,
    ::Val{3};
    kwargs...,
)
    scene = AbstractPlotting.Scene(resolution = scene_resolution, scale_plot = false)
    implicit_plot!(p, f; kwargs...)
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
