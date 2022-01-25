#s = [10.0, 28.0, 8/3]
d = 2
A = reshape([2,1,1,1.0],2,2)
q = eigvecs(A)[:,2]
function next(u, sn)
	u_next = A*u
    noise = sn*randn(d)
    u_next .+= noise
	u_next .%= 1
    return u_next
end

