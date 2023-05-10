classdef Spike
    properties
        height
        baseMid
        orientation

        point1
        point2
        point3
    end

    methods
        function obj = Spike(point1, point2, point3)
            obj.point1 = point1;
            obj.point2 = point2;
            obj.point3 = point3;
            
            midpoint = [(point2(1)+point3(1))/2 (point2(2)+point3(2))/2];
            obj.baseMid = midpoint;
            obj.height = sqrt((point1(1)-midpoint(1))^2 + (point1(2)-midpoint(2))^2);

            obj.orientation = atan2((point1(2)-midpoint(2)),(point1(1)-midpoint(1)));
        end

        function r = getOrientation(obj)
            r = obj.orientation;
        end

        function r = getPoints(obj)
            r = [obj.point1; obj.point2; obj.point3];
        end

        function [X, Y] = getXY(obj)
            X = [obj.point1(1) obj.point2(1) obj.point3(1) obj.point1(1)];
            Y = [obj.point1(2) obj.point2(2) obj.point3(2) obj.point1(2)];
        end
    end
end