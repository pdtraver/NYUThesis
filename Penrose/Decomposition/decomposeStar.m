function [shapes] = decomposeStar(star)
    orientation = star.orientation;
    center = star.center;
    frac_factor = pdist([star.point2; star.point6]);

    %star
    out_star = Star(center, "center", orientation + pi, frac_factor);

    addFrac = 72*pi/180;
    %pents
    side2Rratio = sqrt((5 - sqrt(5))/2);
    %1
    pent1 = Pent(out_star.point6, "point1", out_star.a/side2Rratio, out_star.orientation+pi/2);
    %2
    pent2 = Pent(out_star.point8, "point1", out_star.a/side2Rratio, out_star.orientation+addFrac+pi/2);
    %3
    pent3 = Pent(out_star.point10, "point1", out_star.a/side2Rratio, out_star.orientation+addFrac*2+pi/2);
    %4
    pent4 = Pent(out_star.point2, "point1", out_star.a/side2Rratio, out_star.orientation+addFrac*3+pi/2);
    %5
    pent5 = Pent(out_star.point4, "point1", out_star.a/side2Rratio, out_star.orientation+addFrac*4+pi/2);

    out_pents = [pent1; pent2; pent3; pent4; pent5];

    %boats
    %1
    boat1 = Boat(star.point1, "diamond point1", orientation+pi, frac_factor);
    %2
    boat2 = Boat(star.point3, "diamond point1", orientation+addFrac+pi, frac_factor);
    %3
    boat3 = Boat(star.point5, "diamond point1", orientation+addFrac*2+pi, frac_factor);
    %4
    boat4 = Boat(star.point7, "diamond point1", orientation+addFrac*3+pi, frac_factor);
    %5
    boat5 = Boat(star.point9, "diamond point1", orientation+addFrac*4+pi, frac_factor);

    out_boats = [boat1; boat2; boat3; boat4; boat5];

    shapes = {out_star, out_pents, out_boats};
    
end