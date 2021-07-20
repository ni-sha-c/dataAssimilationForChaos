dt = 0.002
s = [10.0, 28.0, 8/3]
d = 3
function flow(u::Array{Float64,1})
    sigma, rho, beta = s
    x, y, z = u[1], u[2], u[3]
    return [sigma*(y - x), x*(rho - z) - y, x*y - beta*z]
end
function next(u, sn)
    k1 = dt*flow(u)
    k2 = dt*flow(u .+ k1)
    u_next = @. u + (k1 + k2)/2 
	noise = sn*randn(d)
	u_next .+= noise
    return u_next
end

