include("../examples/tent.jl")
using PyPlot
function test_attractor()
    x = LinRange(0., 2π, 200)
    s = 0.1
    fx = next.(x,s)
    fig, ax = subplots()
    ax.plot(x, fx, ".")
end
function test_gaussian()

end

