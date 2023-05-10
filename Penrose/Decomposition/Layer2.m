function [shapes] = Layer2(pents, diamonds)
    
    newPents = [];
    newSpikes = [];
    
    % generate newPents and newSpikes by decomposing larger pentagons from
    % Layer 1
    for i = 1:length(pents)
        [Pents{i}, Spikes{i}] = decomposePent(pents(i));
        newPents = [newPents; Pents{i}];
        newSpikes = [newSpikes; Spikes{i}];
    end

    Stars = [];
    Boats = [];

    %decompose the diamonds from Layer1 into a star, a pent and a boat,
    %adding to the larger arrays already generated
    for i = 1:length(diamonds)
        [Star, Pent, Boat] = decomposeDiamond(diamonds(i));
        newPents = [newPents; Pent];
        Stars = [Stars; Star];
        Boats = [Boats; Boat];
    end


    newDiamonds = [];
    %check three cases:
    %Case1: if a spike overlaps with three points of a boat; if so, remove
    %the spike
    %Case2: if a spike overlaps with two points of another spike; if so,
    %make a diamond from these two spikes and remove the two spikes
    %Case3: if a spike does not overlap at all, turn it into a diamond
    
    counter = length(newSpikes);

    while ~isempty(newSpikes)
        disp("WE LOOPED");

        continueToNext = 0;

        currSpike = newSpikes(1);
        currSpikePoints = currSpike.getPoints;
        currSpikePoints = round(currSpikePoints,3);

        %case1: iterate through boats; check intersection
        for j = 1:length(Boats)
            currBoat = Boats(j);
            currBoatPoints = currBoat.getPoints;
            currBoatPoints = round(currBoatPoints,3);
            if length(intersect(currSpikePoints, currBoatPoints, 'rows')) == 3
                newSpikes(1) = [];
                continueToNext = 1;
                disp("one spike taken away");
                break;
            end
        end

        if continueToNext == 1
            counter = counter - 1;
            continue;
        end

        %case2: iterate through diamonds; check intersection
        for j = 1:length(newSpikes)
            compSpike = newSpikes(j);
            compSpikePoints = compSpike.getPoints;
            compSpikePoints = round(compSpikePoints, 3);
            if length(intersect(currSpikePoints, compSpikePoints, 'rows')) == 2
                newDiamonds = [newDiamonds twoSpikes2Diamond(currSpike, compSpike)];

                newSpikes(j) = [];
                newSpikes(1) = [];
                
                disp("two spikes taken away!");
                continueToNext = 1;
                break;
            end
        end

        if continueToNext == 1
            counter = counter - 2;
            continue;
        end

        %case3: turn all remaining spikes into diamonds
        newDiamonds = [newDiamonds convertSpike2Diamond(currSpike)];
        disp("new diamond made!");
        newSpikes(1) = [];
        counter = counter - 1;
    end
    

    shapes = {newPents, newDiamonds, Stars, Boats};
    figure(2);

    for i = 1:length(newPents)
        currPent = newPents(i);
        [X,Y] = currPent.getXY;
        plot(X,Y);
        drawnow;
        hold on;
        pause(.1);
    end

   
    for i = 1:length(newDiamonds)
        currDiamond = newDiamonds(i);
        [X,Y] = currDiamond.getXY;
        plot(X,Y);
        drawnow;
        hold on;
        pause(.1);
    end

    %{
    for i = 1:length(newSpikes)
        currDiamond = newSpikes(i);
        [X,Y] = currDiamond.getXY;
        plot(X,Y);
        drawnow;
        hold on;
        pause(.1);
    end
    %}

    for i = 1:length(Stars)
        currStar = Stars(i);
        [X,Y] = currStar.getXY;
        plot(X,Y);
        drawnow;
        hold on;
        pause(.1);
    end

    for i = 1:length(Boats)
        currBoat = Boats(i);
        [X,Y] = currBoat.getXY;
        plot(X,Y);
        drawnow;
        hold on;
        pause(.1);
    end


end