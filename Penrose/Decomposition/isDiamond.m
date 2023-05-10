function [Boolean] = isDiamond(spike1, spike2)
    points1 = spike1.getPoints;
    points2 = spike2.getPoints;

    if length(intersect(points1, points2)) == 4
        Boolean = 'True';
    else
        Boolean = 'False';
    end
end