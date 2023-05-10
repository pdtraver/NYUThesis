function plotShapes(shapes)

    figure(1);

    newPents = shapes{1};
    newDiamonds = shapes{2};
    Stars = shapes{3};
    Boats = shapes{4};

    for i = 1:length(newPents)
        currPent = newPents(i);
        [X,Y] = currPent.getXY;
        plot(X,Y);
        hold on;
    end

    for i = 1:length(newDiamonds)
        currDiamond = newDiamonds(i);
        [X,Y] = currDiamond.getXY;
        plot(X,Y);
        hold on;
    end

    for i = 1:length(Stars)
        currStar = Stars(i);
        [X,Y] = currStar.getXY;
        plot(X,Y);
        hold on;
    end

    for i = 1:length(Boats)
        currBoat = Boats(i);
        [X,Y] = currBoat.getXY;
        plot(X,Y);
        hold on;
    end

end