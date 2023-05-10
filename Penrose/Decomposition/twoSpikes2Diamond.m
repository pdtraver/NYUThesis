function [diamond] = twoSpikes2Diamond(spike1, spike2)
    point1 = spike1.point1;
    point2 = spike1.point2;
    point3 = spike2.point1;
    point4 = spike1.point3;

    diamond = Diamond(point1, point2, point3, point4);

end