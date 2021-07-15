include("../examples/tent.jl")
using PyPlot
function test_attractor()
    x = LinRange(0., 2π, 200)
    s = 0.1
    fx = next.(x,s)
    fig, ax = subplots()
    ax.plot(x, fx, ".")
end
function test_gaussian_pushforward(n)
	x = randn(1000000)
	s = 0.2
	for i = 1:n
		x .= next.(x,s)
	end
	hist(x,density=true,bins=100)
	xlabel(L"x",fontsize=30)
	ylabel("\$ \\tilde{\\varphi}^$(n)_\\sharp \\eta \$",fontsize=30)
	tick_params(axis="both",labelsize=30)

end

