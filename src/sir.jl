include("../examples/lorenz.jl")
using JLD
σ_o = 1.0
function p_y_g_x(a)
        term =  log(1/sqrt(2π)/σ_o) 
        return sum(term .- 0.5*a.*a/σ_o/σ_o)
end
function obs(x)
    return x
end
function sir(y,x_ip,s,N_thr=10)
    K = size(y)[2]
    N_p = size(x_ip)[2]
    w_trj = zeros(N_p, K)
    x_trj = zeros(d, N_p, K)


    w = ones(N_p)./N_p
    new_pts = similar(x_ip)
    x = copy(x_ip)
    for k = 1:K
        for i = 1: N_p 
                logwi = log(w[i]) + p_y_g_x(y[:,k] .- obs(x[:,i]))
                w[i] = exp(logwi)
        end

        w ./= sum(w)

        N_eff = 1.0/sum(w.*w)
        if (N_eff < N_thr)
            #resample
            # multinomial resampling
            cdfw = cumsum(w)
            new_pts .= similar(x)
            for j = 1:N_p
                r = rand()
                for i = 1:N_p
                    if cdfw[i] >= r
                        new_pts[:,j] .= x[:,i]
                        break
                    end
                end
            end
            x .= new_pts
        end
        for i = 1:N_p
            x[:,i] .= next(x[:,i],s)
        end

        x_trj[:,:,k] .= x
        w_trj[:,k] .= w
    end
    return x_trj, w_trj
end
function assimilate(K, Np)
    # Often much larger.
    #Np = 1000
    #K = 1000
    x = rand(d,Np)
    s = 0.1
    x_true = ones(d,K)
    x0_true = 2*pi*rand(d)
    Nrunup = 1000
    for i = 1:Nrunup
        x0_true = next(x0_true, 0.0)
    end
    for i = 1:Nrunup
        for j = 1:Np
            x[:,j] = next(x[:,j],s)
        end
    end
    x_true[:,1] .= x0_true
    y = zeros(d,K)
    for i = 2:K
        x_true[:,i] = next(x_true[:,i-1], s)
        y[:,i] = obs(x_true[:,i]) + σ_o*randn(d)
    end
    N_thr = 20
    # store trajectory of w and x.
    x_trj, w_trj = sir(y, x, s, N_thr) 
    return x_trj, w_trj, y 
end



