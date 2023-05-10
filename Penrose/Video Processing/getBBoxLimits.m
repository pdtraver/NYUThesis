WEBCAM = 'C922 Pro Stream Webcam';

cam = webcam(WEBCAM);

peopleDetector = vision.PeopleDetector;

maxArea = 0;
minArea = 10000;
frames = {};
boxed_frames = {};
centers = {};
areas = {};
total_bboxes = {};
total_scores = {};
for i = 1:15
    disp("LOOPED " + i );
    pause(10);
    curr_frame = snapshot(cam);
    [bboxes, scores] = peopleDetector(curr_frame);
    total_bboxes{i} = bboxes;
    total_scores{i} = scores;
    curr_centers = {};
    curr_areas = {};
    for j = 1:length(scores)
        %if scores(j) < .8
            frames{i} = curr_frame;
            curr_frame = insertShape(curr_frame, 'rectangle', bboxes(j,:));
            center = [bboxes(j,1)-bboxes(j,3)/2, bboxes(j,2)-bboxes(j,4)/2];
            curr_centers{j} = center;
            curr_frame = insertMarker(curr_frame, center, "circle");
            boxed_frames{i} = curr_frame;
            area = bboxes(j,3)* bboxes(j,4);
            curr_areas{j} = area;
            if area > maxArea
                maxArea = area;
            end
            if area < minArea
                minArea = area;
            end
        %end
    end
    centers{i} = curr_centers;
    areas{i} = curr_areas;
    curr_frame = imresize(curr_frame, .5);
    figure(1); imshow(curr_frame);
end

%{
797   152   269   538
685   187   497   894
1465         126         456         940
1431         134         332         665
1351         136         196         392
878   149   188   376
377   148   183   365
100   121   315   630
1   147   341   778
1318         297          82         163
617   152   371   742
835   152   211   423
1122         134         278         556
%}

% above are the 13 bboxes used to calibrate my system
% the first one is at the center
% the rest can be interpreted based on their location