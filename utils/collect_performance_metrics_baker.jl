include("../src/sir.jl")
using PyPlot

function no_of_particles()
	K = 50
	σ_o = 0.1
	σ_d = 0.0
	Δ = 5
	Nth = 500
	obsfun = obs
	
	Npts = 10
	Np = 100

	trj_len = K*Δ
	mean_rmse = zeros(Npts)
	Np_arr = zeros(Int64, Npts)

	for i = 1:Npts
	   @show Np
	   mean_rmse[i] = assimilate(K, Np, 
							σ_o, σ_d,
							Δ, Nth, 
							obsfun)

	   Np_arr[i] = Np
	   Np = Np + 500
	end
	save("../data/mean_rmse_vs_Np_full.jld", "Np", Np_arr, "mean_rmse", mean_rmse) 
end



