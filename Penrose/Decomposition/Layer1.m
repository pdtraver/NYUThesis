function [shapes] = Layer1(pentagon)
    [pents, spikes] = decomposePent(pentagon);
    
    d1 = convertSpike2Diamond(spikes(1));
    d2 = convertSpike2Diamond(spikes(2));
    d3 = convertSpike2Diamond(spikes(3));
    d4 = convertSpike2Diamond(spikes(4));
    d5 = convertSpike2Diamond(spikes(5));

    diamonds = [d1; d2; d3; d4; d5];

    shapes = {pents, diamonds};

    for i = 1:length(pents)
        currPent = pents(i);
        [X,Y] = currPent.getXY;
        plot(X,Y);
        drawnow;
        hold on;
        pause(.1);
    end

    for i = 1:length(diamonds)
        currDiamond = diamonds(i);
        [X,Y] = currDiamond.getXY;
        plot(X,Y);
        drawnow;
        hold on;
        pause(.1);
    end
end