classdef Pent
    properties
        center
        radius
        orientation
        edge

        point1
        point2
        point3
        point4
        point5

        note1
        note2
        note3
        note4
        note5
    end

    methods
        function obj = Pent(point, pointLabel, radius, orientation)
            % point1 == top; point2 == topleft; point3 == bottomleft;
            % point4 == bottomright; point5 == topright
            c1 = cos(2*pi/5);
            c2 = cos(pi/5);
            s1 = sin(2*pi/5);
            s2 = sin(4*pi/5);

            obj.radius = radius;
            obj.orientation = orientation;

            % flip the sign of the center offset if the pentagon is upside
            % down
            if orientation == 0
                sign = 1;
            else
                %set sign to 1 for test
                sign = -1;
            end

            offset = pi/2;

            if pointLabel == "point1"
                obj.point1 = point;
                angle = orientation + (72*pi/180)*0 + pi + offset;
                obj.center = obj.point1 + [radius*cos(angle) radius*sin(angle)];
            elseif pointLabel == "point2"
                obj.point2 = point;
                angle = orientation + (72*pi/180)*1 + pi + offset;
                obj.center = obj.point2 + [radius*cos(angle) radius*sin(angle)];
            elseif pointLabel == "point3"
                obj.point3 = point;
                angle = orientation + (72*pi/180)*2 + pi + offset;
                obj.center = obj.point3 + [radius*cos(angle) radius*sin(angle)];
            elseif pointLabel == "point4"
                obj.point4 = point;
                angle = orientation + (72*pi/180)*3 + pi + offset;
                obj.center = obj.point4 + [radius*cos(angle) radius*sin(angle)];
            elseif pointLabel == "point5"
                obj.point5 = point;
                angle = orientation + (72*pi/180)*4 + pi + offset;
                obj.center = obj.point5 + [radius*cos(angle) radius*sin(angle)];
            elseif pointLabel == "center"
                obj.center = point;
            end
            
            x = obj.center(1);
            y = obj.center(2);

            % Non-standard rotation matrix used -- for some reason it was
            % rotating clockwise instead of counter clockwise with the
            % standard model
            rotationMat = [cos(orientation) sin(orientation);
                           -sin(orientation) cos(orientation)];

            obj.point1 = ([0 radius])*rotationMat + [x y];
            obj.point2 = ([-s1*radius c1*radius])*rotationMat + [x y];
            obj.point3 = ([-s2*radius -c2*radius])*rotationMat + [x y];
            obj.point4 = ([s2*radius -c2*radius])*rotationMat + [x y];
            obj.point5 = ([s1*radius c1*radius])*rotationMat + [x y];

            obj.edge = sqrt((obj.point1(1)-obj.point2(1))^2 + (obj.point1(2)-obj.point2(2)^2));

            obj.note1 = [];
            obj.note2 = [];
            obj.note3 = [];
            obj.note4 = [];
            obj.note5 = [];
        end

        function r = getCenter(obj)
            r = obj.center;
        end

        function r = getRadius(obj)
            r = obj.radius;
        end

        function r = getOrientation(obj)
            r = obj.orientation;
        end

        function r = getNote1(obj)
            r = obj.note1;
        end

        function r = getNote2(obj)
            r = obj.note2;
        end

        function r = getNote3(obj)
            r = obj.note3;
        end

        function r = getNote4(obj)
            r = obj.note4;
        end

        function r = getNote5(obj)
            r = obj.note5;
        end

        function r = getSmallRadius(obj)
            r = obj.radius*(sqrt(25 + 10*sqrt(5))/sqrt(50 + 10*sqrt(5)));
        end

        function r = isFilled(obj)
            if isempty(obj.note1) && isempty(obj.note2) && isempty(obj.note3) && isempty(obj.note4) && isempty(obj.note5)
                r = 0;
            else
                r = 1;
            end
        end  

        function r = getPoints(obj)
            r = [obj.point1; obj.point2; obj.point3; obj.point4; obj.point5];
        end

        function [X, Y] = getXY(obj)
            X = [obj.point1(1) obj.point2(1) obj.point3(1) obj.point4(1) obj.point5(1) obj.point1(1)];
            Y = [obj.point1(2) obj.point2(2) obj.point3(2) obj.point4(2) obj.point5(2) obj.point1(2)];
        end

        function fillNotes(axes, inNote1, label1)
            if label1 == "note1"
                obj.note1 = inNote1;
            elseif label1 == "note2"
                obj.note2 = inNote1;
            elseif label1 == "note3"
                obj.note3 = inNote1;
            elseif label1 == "note4"
                obj.note4 = inNote1;
            elseif label1 == "note5"
                obj.note5 = inNote1;
            end

            obj.note1 = obj.note5 + axes(5);
            obj.note2 = obj.note1 + axes(1);
            obj.note3 = obj.note2 + axes(2);
            obj.note4 = obj.note3 + axes(3);
            obj.note5 = obj.note4 + axes(4);
            

        end
    end
end