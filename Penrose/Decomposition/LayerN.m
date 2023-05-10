function [shapes] = LayerN(pents, diamonds, stars, boats, N)
    
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

    for i = 1:length(boats)
        newShapes = decomposeBoat(boats(i));
        boatStars = newShapes{1};
        boatPents = newShapes{2};
        boatBoats = newShapes{3};
        newPents = [newPents; boatPents];
        Stars = [Stars; boatStars];
        Boats = [Boats; boatBoats];
    end

    for i = 1:length(stars)
        newShapes = decomposeStar(stars(i));
        starStars = newShapes{1};
        starPents = newShapes{2};
        starBoats = newShapes{3};
        newPents = [newPents; starPents];
        Stars = [Stars; starStars];
        Boats = [Boats; starBoats];
    end


    newDiamonds = [];
    %check three cases:
    %Case1: if a spike overlaps with three points of a boat; if so, remove
    %the spike
    %Case2: if a spike overlaps with two points of another spike; if so,
    %make a diamond from these two spikes and remove the two spikes
    %Case3: if a spike does not overlap at all, turn it into a diamond
    
    counter = length(newSpikes);
    roundFactor = 2;

    boatOverlaps = 0;
    starOverlaps = 0;
    spikeOverlaps = 0;
    noOverlaps = 0;

    while ~isempty(newSpikes)

        continueToNext = 0;

        currSpike = newSpikes(1);
        currSpikePoints = currSpike.getPoints;
        currSpikePoints = round(currSpikePoints,roundFactor, 'significant');

        %case1: iterate through boats; check intersection
        for j = 1:length(Boats)
            currBoat = Boats(j);
            currBoatPoints = currBoat.getPoints;
            currBoatPoints = round(currBoatPoints,roundFactor, 'significant');
            if length(intersect(currSpikePoints, currBoatPoints, 'rows')) == 3
                newSpikes(1) = [];
                continueToNext = 1;
                boatOverlaps = boatOverlaps + 1;
                break;
            end
        end

        if continueToNext == 1
            counter = counter - 1;
            continue;
        end

         %case1.5: iterate through stars; check intersection
        for j = 1:length(Stars)
            currStar = Stars(j);
            currStarPoints = currStar.getPoints;
            currStarPoints = round(currStarPoints,roundFactor, 'significant');
            if length(intersect(currSpikePoints, currStarPoints, 'rows')) == 3
                newSpikes(1) = [];
                continueToNext = 1;
                starOverlaps = starOverlaps + 1;
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
            compSpikePoints = round(compSpikePoints, roundFactor, 'significant');
            if length(intersect(currSpikePoints, compSpikePoints, 'rows')) == 2
                newDiamonds = [newDiamonds twoSpikes2Diamond(currSpike, compSpike)];

                newSpikes(j) = [];
                newSpikes(1) = [];

                continueToNext = 1;

                spikeOverlaps = spikeOverlaps + 1;
                break;
            end
        end

        if continueToNext == 1
            counter = counter - 2;
            continue;
        end

        %case3: turn all remaining spikes into diamonds
        newDiamonds = [newDiamonds convertSpike2Diamond(currSpike)];
        newSpikes(1) = [];
        noOverlaps = noOverlaps + 1;
        counter = counter - 1;
    end

    disp("boat overlaps, star overlaps, spike overlaps, no overlaps");
    overlaps = [boatOverlaps, starOverlaps, spikeOverlaps, noOverlaps];
    disp(overlaps);
    

    shapes = {newPents, transpose(newDiamonds), Stars, Boats};
    figure(N);

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