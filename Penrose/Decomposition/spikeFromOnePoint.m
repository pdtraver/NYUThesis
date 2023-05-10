function [spike] = spikeFromOnePoint(point, orientation, longEdgeLength)
    %longEdgeLength is the length of the edge of the spike going to be made
    offset = 18*pi/180;
    point1 = point;
    point2 = [point1(1)-longEdgeLength*cos(orientation-offset), point1(2)-longEdgeLength*sin(orientation-offset)];
    point3 = [point1(1)-longEdgeLength*cos(orientation+offset), point1(2)-longEdgeLength*sin(orientation+offset)];
    
    spike = Spike(point1, point2, point3);
end