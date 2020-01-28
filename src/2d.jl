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
    implicit_curve!(p, f; x_min=-5, x_max=5, y_min=x_min, y_max=x_max,
                        color=:steelblue, resolution=1000)

Visualize the implicit curve `f` in the box `[x_min, x_max] × [y_min, y_max]`.
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
