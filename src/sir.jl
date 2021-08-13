include("../examples/lorenz.jl")
using JLD
using LinearAlgebra
function p_y_g_x(a, σ_o)
        term =  log(1/sqrt(2π)/σ_o) 
        return sum(term .- 0.5*a.*a/σ_o/σ_o)
end
function obs(x, σ_o)
    return x .+ σ_o*randn(d)
end
function obs1(x, σ_o)
	return [x[3] + σ_o*randn()]
end

function resample(x, w)
    # multinomial resampling
    cdfw = cumsum(w)
    new_pts = similar(x)
	N_p = size(w)[1]
    for j = 1:N_p
        r = rand()
        for i = 1:N_p
            if cdfw[i] >= r
                new_pts[:,j] .= x[:,i]
                break
            end
        end
    end
    return new_pts
end

function sir(y,x_t,x_ip,Δ,obs_fun,σ_o,σ_d,N_thr=10)
    K = size(y)[2]
    N_p = size(x_ip)[2]
    
    N_y = K*Δ
	@show N_y
    rmse_trj = zeros(K)
    N_runup = 3000

	w = SharedArray{Float64}(N_p)
	w .= 1.0/N_p
	x = SharedArray{Float64}(d,N_p)
	t = @distributed for i=1:N_p
		x[:,i] = rand(d)
		for k = 1:N_runup
			x[:,i] = next(x[:,i],s) 
		end
	end
	wait(t)

	mean_x = zeros(d,K)    
    j = 1
	count = 0
    for k = 1:N_y
        if k % Δ == 0
			filter_mean = sum(x,dims=2)/N_p
			rmse_trj[j] = norm(filter_mean - x_t[:,k])/sqrt(d)

			t = @distributed for i = 1: N_p 
                logwi = log(w[i]) + p_y_g_x(y[:,j] .- obs_fun(x[:,i],σ_o), σ_o)
                w[i] = exp(logwi)
			end
            w ./= sum(w)
            N_eff = 1.0/sum(w.*w)
            if (N_eff < N_thr)
				count = count + 1
			    x .= resample(x, w)
		    end
			j = j+1
		end
        for i = 1:N_p
            x[:,i] .= next(x[:,i],σ_d)
        end
    end
	@show "Resampling was triggered ", count, " times out of ", N_y
    return rmse_trj
end
"""
    assimilate(K, Np, σ_o, σ_d, 
				   Δ, Nth)

Perform `K` data assimilation steps using an SIR algorithm with `Np` particles. Other inputs:

    1. `σ_o`: std of Gaussian observation noise
	2. `σ_d`: std of Gaussian dynamics noise, which is added to every component and at every timestep.
	3. `Δ`: inter-observation number of timesteps, e.g., if `Δ = 5,` observations are assumed available at timestep `0,5,10,...,5(K-1)`.
	4. `Nth`: number of particles below which to resample
	5. `obs`: observation map, e.g., `obs(x) = x[3]`

Output: 

`mean_rmse`: Summary scalar performance metric: 

# Examples
```julia-repl
julia> rmse_avg = assimilate(500, 1000, 0.1, 0.1, 1, 10, obs)
```
"""
function assimilate(K, Np, σ_o, σ_d, 
				   Δ, Nth, obsfun)
	Ny = K*Δ
	ytest = obsfun(rand(d),σ_o)
	dy = size(ytest)[1]
    x_true = ones(d,Ny)
    x0_true = rand(d)
    Nrunup = 2000
    for i = 1:Nrunup
        x0_true = next(x0_true, 0.0)
    end
    x_true[:,1] .= x0_true
    y = zeros(dy, K)
	y[:,1] .= obsfun(x0_true, σ_o) 
	k = 1
    for i = 2:Ny
        x_true[:,i] = next(x_true[:,i-1], σ_d)
		if i % Δ == 0
        	y[:,k] .= obsfun(x_true[:,i], σ_o)
			k = k+1
		end
    end
    # store trajectory of w and x.
    rmse_trj = sir(y, x_true, Δ, obsfun, σ_o, σ_d, Nth)
	mean_rmse = sum(rmse_trj)/K
    return mean_rmse
end




