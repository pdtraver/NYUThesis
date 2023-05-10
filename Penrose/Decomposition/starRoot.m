function F = starRoot(in)

    L = in(1);
    a = in(2);
    b = in(3);
    r = in(4);
    R = in(5);
    p = in(6);
    x = in(7);
    y = in(8);
    

    F(1) = 2*a + b - L;
    F(2) = (b/2)^2 + r^2 - R^2;
    F(3) = r^2 + (a + b/2)^2 - p^2;
    F(4) = (p - r)^2 + (b/2)^2 - a^2;
    F(5) = x^2 + (R + p + y)^2 - L;
    F(6) = x^2 + y^2 - a^2;
    F(7) = (R + y)^2 + x^2 - p^2;

end