include("../examples/lorenz.jl")
using JLD
σ_o = 0.1
function p_y_g_x(a)
        term =  log(1/sqrt(2π)/σ_o) 
        return sum(term .- 0.5*a.*a/σ_o/σ_o)
end
function obs(x)
    return x .+ σ_o*randn(d)
end
function obs1(x)
    return x[3] + σ_o*randn()
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
function sir(y,x_ip,s,obs_fun,N_thr=10)
    K = size(y)[2]
    N_p = size(x_ip)[2]
    w_trj = zeros(N_p, K)
    x_trj = zeros(d, N_p, K)


    w = ones(N_p)./N_p
    x = copy(x_ip)
    for k = 1:K
        for i = 1: N_p 
                logwi = log(w[i]) + p_y_g_x(y[:,k] .- obs_fun(x[:,i]))
                w[i] = exp(logwi)
        end

        w ./= sum(w)

        N_eff = 1.0/sum(w.*w)
        if (N_eff < N_thr)
			x .= resample(x, w)
		end
        for i = 1:N_p
            x[:,i] .= next(x[:,i],s)
        end

        x_trj[:,:,k] .= x
        w_trj[:,k] .= w
    end
    return x_trj, w_trj
end
"""
    assimilate(K, Np, σ_o, σ_d, 
				   Δ, Nth)

Perform `K` data assimilation steps using an SIR algorithm with `Np` particles. Other inputs:

    1. `σ_o`: std of Gaussian observation noise
	2. `σ_d`: std of Gaussian dynamics noise, which is added to every component and at every timestep.
	3. `Δ`: inter-observation number of timesteps, e.g., if `Δ = 5,` observations are assumed available at timestep `0,5,10,...,5(K-1)`.
	4. `Nth`: number of particles below which to resample

Outputs:

    1. `x`: orbit of particles. size: `dX x Np x (Δ K)`
	2. `w`: orbit of weights. size: `Np x (Δ K)`
	3. `y`: synthetic observations. size: `dY x K`  

# Examples
```julia-repl
julia> x, w = assimilate(500, 1000, 0.1, 0.1, 1)
```
"""
function assimilate(K, Np, σ_o, σ_d, 
				   Δ)
    x = rand(d,Np)
    x_true = ones(d,K)
    x0_true = rand(d)
    Nrunup = 2000
    for i = 1:Nrunup
        x0_true = next(x0_true, 0.0)
    end
    for i = 1:Nrunup
        for j = 1:Np
            x[:,j] = next(x[:,j],s)
        end
    end
    x_true[:,1] .= x0_true
    y = zeros(1,K)
	y[:,1] .= obs1(x0_true) 
    for i = 2:K
        x_true[:,i] = next(x_true[:,i-1], s)
        y[:,i] .= obs1(x_true[:,i]) 
    end
    N_thr = 20
    # store trajectory of w and x.
    x_trj, w_trj = sir(y, x, s, obs1, N_thr) 
    return x_trj, w_trj, y 
end



