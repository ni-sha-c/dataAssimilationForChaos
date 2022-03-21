d = 2
function next(u, s=[0.,0.,0.,0.])
    x, y = u[1], u[2]
    sx, sy = sin(x), sin(2*y)/2
    x1 = (2*x +
            (s[1] + s[2]*sy)*sx)
    y1 = (0.5*y +
            (s[4] + s[3]*sx)*sy)

    x_next = x < pi ? x1 : x1 - 2*pi
    y_next = x < pi ? y1 : y1 + pi

    x_next = x_next % (2*pi)
    y_next = y_next % (2*pi)

    return [x_next, y_next]
end

