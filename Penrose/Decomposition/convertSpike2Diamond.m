function [diamond] = convertSpike2Diamond(spike)
    point1 = spike.point1;
    point2 = spike.point2;
    point4 = spike.point3;

    baseMid = spike.baseMid;

    rotationMat = [cos(pi) sin(pi);
                   -sin(pi) cos(pi)];

    point3 = (point1-baseMid)*rotationMat + baseMid;

    diamond = Diamond(point1, point2, point3, point4);
end