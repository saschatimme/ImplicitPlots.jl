import .AbstractPlotting

function implicit_plot(f, ::Val{3}; resolution = (800, 800), kwargs...)
    scene = AbstractPlotting.Scene(resolution = resolution, scale_plot = false)
    implicit_surface!(scene, f; kwargs...)
end
implicit_plot!(p, f, ::Val{3}; kwargs...) = implicit_surface!(p, f; kwargs...)

"""
    implicit_surface!(scene, f; xlims=(-3,3), ylims = xlims, zlims = xlims,
                      color=:steelblue, resolution=1000)

Visualize the implicit suface `f` in the box `[x_min, x_max] × [y_min, y_max] × [z_min, z_max]`.
"""
function implicit_surface!(
    scene,
    f;
    x_min = -3.0,
    xmin = x_min,
    x_max = 3.0,
    xmax = x_max,
    y_min = xmin,
    ymin = y_min,
    y_max = xmax,
    ymax = y_max,
    z_min = xmin,
    zmin = z_min,
    z_max = xmax,
    zmax = z_max,
    xlims = (xmin, xmax),
    ylims = (ymin, ymax),
    zlims = (zmin, zmax),
    color = :steelblue,
    show_axis = true,
    wireframe = false,
    mesh_resolution = 0.04,
    grid = true,
    kwargs...,
)
    g = make_function(f)
    box = GeometryTypes.HyperRectangle(
        AbstractPlotting.Vec(xlims[1], ylims[1], float(zlims[1])),
        AbstractPlotting.Vec(
            float(xlims[2] - xlims[1]),
            ylims[2] - ylims[1],
            zlims[2] - zlims[1],
        ),
    )
    sdf = Meshing.SignedDistanceField(v -> g(v...), box, mesh_resolution)
    m = Meshing.GLNormalMesh(sdf, Meshing.MarchingTetrahedra())
    if wireframe === nothing || !wireframe
        AbstractPlotting.mesh!(
            scene,
            m;
            show_axis = show_axis,
            color = color,
            kwargs...,
        )
    else
        AbstractPlotting.wireframe!(scene, m; show_axis = show_axis, kwargs...)
    end

    scene
end
