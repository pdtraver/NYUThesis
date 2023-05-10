function [star_out, pent_out, boat_out] = decomposeDiamond(diamond)
    L_factor = pdist([diamond.point1;diamond.point2]);

    boat_out = Boat(diamond.point1, "diamond point1", diamond.orientation, L_factor);
    star_out = Star(diamond.point3, "diamond point3", diamond.orientation, L_factor);

    side2Rratio = sqrt((5 - sqrt(5))/2);
    pent_out = Pent(boat_out.point4, "point4", pdist([boat_out.point4;boat_out.point5])/side2Rratio, diamond.orientation+ pi/2);
end