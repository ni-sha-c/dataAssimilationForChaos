#s = [10.0, 28.0, 8/3]
d = 2
function next(u, sn)
    u_next = zeros(d)
	u_next[1] = 2*u[1] + u[2]
	u_next[2] = u[1] + u[2]
    noise = sn*randn(d)
    u_next .+= noise
	u_next .%= 1
    return u_next
end

