using ImplicitPlots
using Test
import Plots
using DynamicPolynomials: @polyvar
using HomotopyContinuation: @var

@testset "ImplicitPlots.jl" begin

    f(x,y) = (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y
    @test implicit_plot(f; xlims=(-2,2), ylims=(-2,2)) isa Plots.Plot

    @polyvar x y
    f2 = (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y
    @test implicit_plot(f2; xlims=(-2,2), ylims=(-2,2)) isa Plots.Plot

    @var x y
    f3 = (x^4 + y^4 - 1) * (x^2 + y^2 - 2) + x^5 * y
    @test implicit_plot(f3; xlims=(-2,2), ylims=(-2,2)) isa Plots.Plot
end
