using ImplicitPlots
using Test

# import AbstractPlotting
import Plots

@testset "ImplicitPlots.jl" begin

    f(x,y) = (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y
    @test implicit_plot(f; xlims=(-2,2), ylims=(-2,2)) isa Plots.Plot

    # g(x,y,z) = (0.3*x^2+0.5z-0.3x+1.2*y^2-1.1)^2+(0.7*(y+0.5x)^2+y+1.2*z^2-1)^2-0.3
    # @test implicit_plot(g) isa AbstractPlotting.Scene

    @polyvar x y
    f2 = (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y
    @test implicit_plot(f2; xlims=(-2,2), ylims=(-2,2)) isa Plots.Plot

    # g2 = (0.3*x^2+0.5z-0.3x+1.2*y^2-1.1)^2+(0.7*(y+0.5x)^2+y+1.2*z^2-1)^2-0.3
    # @test implicit_plot(g2) isa AbstractPlotting.Scene
end
