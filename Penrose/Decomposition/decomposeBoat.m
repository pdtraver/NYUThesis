function [shapes] = decomposeBoat(boat)
    orientation = boat.orientation;
    center = boat.center;
    frac_factor = pdist([boat.point2; boat.point5]);

    %star
    out_star = Star(center, "center", orientation, frac_factor);

    addFrac = 72*pi/180;
    %pents
    side2Rratio = sqrt((5 - sqrt(5))/2);
    %1
    pent1 = Pent(out_star.point6, "point1", out_star.a/side2Rratio, out_star.orientation+pi/2);
    %2
    pent2 = Pent(out_star.point8, "point1", out_star.a/side2Rratio, out_star.orientation+addFrac+pi/2);
    %3
    pent3 = Pent(out_star.point4, "point1", out_star.a/side2Rratio, out_star.orientation+addFrac*4+pi/2);

    out_pents = [pent1; pent2; pent3];

    %boats
    %1
    boat1 = Boat(boat.point1, "diamond point1", orientation, frac_factor);
    %2
    boat2 = Boat(boat.point3, "diamond point1", orientation+addFrac, frac_factor);
    %3
    boat3 = Boat(boat.point6, "diamond point1", orientation+addFrac*4, frac_factor);

    out_boats = [boat1; boat2; boat3];

    shapes = {out_star, out_pents, out_boats};
    
end