classdef Diamond
    properties
        center
        orientation

        point1
        point2
        point3
        point4

        note1
        note2
        note3
        note4
    end

    methods
        function obj = Diamond(point1, point2, point3, point4)
            % point1 and point3 have the longest distance; point 2 and 4
            % have the shortest distance; otherwise 1&3 and 2&4 are
            % interchangeable
            obj.point1 = point1;
            obj.point2 = point2;
            obj.point3 = point3;
            obj.point4 = point4;

            obj.center = [(point2(1)+point4(1))/2 (point2(2)+point4(2))/2];
            obj.orientation = atan2((obj.point1(2)-obj.center(2)),(obj.point1(1)-obj.center(1)));
        end

        function r = getPoints(obj)
            r = [obj.point1; obj.point2; obj.point3; obj.point4];
        end

        function [X, Y] = getXY(obj)
            X = [obj.point1(1) obj.point2(1) obj.point3(1) obj.point4(1) obj.point1(1)];
            Y = [obj.point1(2) obj.point2(2) obj.point3(2) obj.point4(2) obj.point1(2)];
        end
    end
end