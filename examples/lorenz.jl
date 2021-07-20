dt = 0.002
function flow(u::Array{Float64,1},s::Array{Float64,1})
    sigma, rho, beta = s
    x, y, z = u[1], u[2], u[3]
    return [sigma*(y - x), x*(rho - z) - y, x*y - beta*z]
end
function next(u, s)
    k1 = dt*flow(u, s)
    k2 = dt*flow(u .+ k1, s)
    u_next = @. u + (k1 + k2)/2 
    return u_next
end

