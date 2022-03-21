#s = [10.0, 28.0, 8/3]
d = 2
A = reshape([2,1,1,1.0],2,2)
q = eigvecs(A)[:,2]
s2 = 0.2
pert(s1, s2, x) = (1/π)*atan(s1*sin(2*π*x - s2)/(1 - s1*cos(2*π*x - s2)))	 
function next(u, s1)
	u_next = A*u
	per = pert(s1, s2, u[1])
	u_next .+= per
	u_next .%= 1
    return u_next
end

