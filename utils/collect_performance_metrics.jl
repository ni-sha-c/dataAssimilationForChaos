include("../src/sir.jl")
using PyPlot

function no_of_particles()
	K = 50
	σ_o = 0.1
	σ_d = 0.0
	Δ = 5
	Nth = 500
	obsfun = obs1
	
	Npts = 8
	Np = 100

	trj_len = K*Δ
	mean_rmse = zeros(Npts)
	Np_arr = zeros(Int64, Npts)

	for i = 1:Npts
	   @show Np
	   x_trj, w_trj, y, x_true = assimilate(K, Np, 
							σ_o, σ_d,
							Δ, Nth, 
							obsfun)
	    x_trj = permutedims(x_trj,[3,2,1])

	    x_true = permutedims(x_true,[2,1])


        filter_mean = reshape(sum(x_trj,dims=2)/Np, trj_len, d) 
        norm2(x,dim) = sum(x -> x^2, x, dims=dim)
        rmse = norm2(x_true .- filter_mean, 2) 
	    rmse .= sqrt.(rmse)/d
	    mean_rmse[i] = sum(rmse[1:Δ:end])/K
		Np_arr[i] = Np
		Np = Np*2
	end
	save("../data/mean_rmse_vs_Np.jld", "Np", Np_arr, "mean_rmse", mean_rmse) 
end



