classdef Boat
    properties
        center
        orientation

        point1
        point2
        point3
        point4
        point5
        point6
        point7

        frac_factor

        L
        a
        b
        r
        R
        p
        x
        y

        note1
        note2
        note3
        note4
        note5
        note6
        note7
    end

    methods
        function obj = Boat(point, pointLabel, orientation, frac_factor)
            obj.frac_factor = frac_factor;
            obj.orientation = orientation;

            obj.L   =   frac_factor;
            obj.a	=	(1/2)*(3-sqrt(5))*frac_factor;
            obj.b	=	(sqrt(5)-2)*frac_factor;
            obj.r	=	((1/2)*sqrt((1/5)*(5-2*sqrt(5))))*frac_factor;
            obj.R	=	sqrt((1/10)*(25-11*sqrt(5)))*frac_factor;
            obj.p	=	sqrt((1/10)*(5-sqrt(5)))*frac_factor;
            obj.x	=	((1/4)*(sqrt(5)-1))*frac_factor;
            obj.y	=	((1/2)*sqrt((1/2)*(25-11*sqrt(5))))*frac_factor;

            if pointLabel == "center"
                obj.center = point;
            elseif pointLabel == "diamond point1"
                obj.center = point + [obj.p*cos(obj.orientation + pi) obj.p*sin(obj.orientation + pi)];
            end

            rotationMat = [cos(obj.orientation) sin(obj.orientation);
                           -sin(obj.orientation) cos(obj.orientation)];
            [x,y]=circle(0, 0, obj.p, 5);
            [x1,y1]=circle(0, 0, obj.R, 10);
            px=[x(1)  x1(2) x(2) x1(4) x1(8) x(5) x1(10) x(1)];
            py=[y(1)  y1(2) y(2) y1(4) y1(8) y(5) y1(10) y(1)];

            for i = 1:length(px)
                outputBoat(i,:) = [px(i) py(i)]*rotationMat;
            end

            obj.point1 = outputBoat(1,:) + obj.center;
            obj.point2 = outputBoat(2,:) + obj.center;
            obj.point3 = outputBoat(3,:) + obj.center;
            obj.point4 = outputBoat(4,:) + obj.center;
            obj.point5 = outputBoat(5,:) + obj.center;
            obj.point6 = outputBoat(6,:) + obj.center;
            obj.point7 = outputBoat(7,:) + obj.center;

        end

        function r = getPoints(obj)
            r = [obj.point1; obj.point2; obj.point3; obj.point4; obj.point5; obj.point6; obj.point7];
        end

        function [X, Y] = getXY(obj)
            X = [obj.point1(1) obj.point2(1) obj.point3(1) obj.point4(1) obj.point5(1) ...
                 obj.point6(1) obj.point7(1) obj.point1(1)];
            Y = [obj.point1(2) obj.point2(2) obj.point3(2) obj.point4(2) obj.point5(2) ...
                 obj.point6(2) obj.point7(2) obj.point1(2)];
        end   

    end
end