if orientation == 0
                sign = 1;
            else
                %set sign to 1 for test
                sign = -1;
            end

            if pointLabel == 'point1'
                obj.point1 = point;
                obj.center = [obj.point1(1), obj.point1(2) - sign*radius];
            elseif pointLabel == 'point2'
                obj.point2 = point;
                obj.center = [obj.point2(1)+sign*s1*radius, obj.point2(2) - sign*c1*radius];
            elseif pointLabel == 'point3'
                obj.point3 = point;
                obj.center = [obj.point3(1)+sign*s2*radius, obj.point3(2) + sign*c2*radius];
            elseif pointLabel == 'point4'
                obj.point4 = point;
                obj.center = [obj.point4(1)-sign*s2*radius, obj.point4(2) + sign*c2*radius];
            elseif pointLabel == 'point5'
                obj.point5 = point;
                obj.center = [obj.point5(1)-sign*s1*radius, obj.point5(2) - sign*c1*radius];
            elseif pointLabel == 'center'
                obj.center = point;
            end






disp(newSpikes);
    for i = 1:length(newSpikes)
        currSpike = newSpikes(1);
        currSpikePoints = round(currSpike.getPoints,4);

        %case1: iterate through boats; check intersection
        for j = 1:length(Boats)
            currBoat = Boats(j);
            currBoatPoints = round(currBoat.getPoints,4);
            if length(intersect(currSpikePoints, currBoatPoints, 'rows')) == 3
                newSpikes(i) = [];
                break;
            end
        end
    end

    for i = 1:length(newSpikes)
        currSpike = newSpikes(1);
        currSpikePoints = currSpike.getPoints;
        %case2: iterate through diamonds; check intersection
        for j = 1:length(newSpikes)
            compSpike = newSpikes(j);
            compSpikePoints = round(compSpike.getPoints,4);
            if length(intersect(currSpikePoints, compSpikePoints, 'rows')) == 2
                newDiamonds = [newDiamonds twoSpikes2Diamond(currSpike, compSpike)];
                if i < j
                    newSpikes(j) = [];
                    newSpikes(i) = [];
                else
                    newSpikes(i) = [];
                    newSpikes(j) = [];
                end
                break;
            end
        end
    end

    for i = 1:length(newSpikes)
        currSpike = newSpikes(i);
        currSpikePoints = currSpike.getPoints;
        newDiamonds = [newDiamonds convertSpike2Diamond(currSpike)];
        disp("new diamond made!");
    end
