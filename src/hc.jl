const HC = HomotopyContinuation

ImplicitFunction(f::HC.ModelKit.Expression) = ImplicitFunction(HC.System([f]))
ImplicitFunction(f::HC.ModelKit.System) = ImplicitFunction(HC.CompiledSystem(f))
function ImplicitFunction(F::HC.AbstractSystem)
    ImplicitFunction{HC.nvariables(F)}((x,y) -> first(F(SVector(x,y))))
end
