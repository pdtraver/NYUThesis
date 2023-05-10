function [xx,yy] = circle(cx, cy, r, n)
    t=linspace(0, 2*pi, n+1);
    x=r*cos(t);
    y=r*sin(t);
    xx= x+cx; 
    yy= y+cy; 
end