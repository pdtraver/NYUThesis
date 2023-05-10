function [Pents, Spikes] = decomposePent(pentagon)
    radius = pentagon.radius;
    orientation = pentagon.orientation;
    center = pentagon.center;
    factor = .382;
    frac_radius = factor*radius;

    midPent = Pent(center, 'center', frac_radius, mod(orientation+pi, 2*pi));
    topcenter = Pent(pentagon.point1, 'point1', frac_radius, orientation);
    topleft = Pent(pentagon.point2, 'point2', frac_radius, orientation);
    bottomleft = Pent(pentagon.point3, 'point3', frac_radius, orientation);
    bottomright = Pent(pentagon.point4, 'point4', frac_radius, orientation);
    topright = Pent(pentagon.point5, 'point5', frac_radius, orientation);

    Pents = [midPent; topcenter; topleft; bottomleft; bottomright; topright];

    %spikes labeled according to which midPent point it starts on
    %angles are in reference to normal orientation with diamond pointing up
    spike4 = Spike(midPent.point4, topcenter.point2, topleft.point1);
    spike5 = Spike(midPent.point5, topleft.point3, bottomleft.point2);
    spike1 = Spike(midPent.point1, bottomleft.point4, bottomright.point3);
    spike2 = Spike(midPent.point2, bottomright.point5, topright.point4);
    spike3 = Spike(midPent.point3, topright.point1, topcenter.point5);

    Spikes = [spike1; spike2; spike3; spike4; spike5];
end