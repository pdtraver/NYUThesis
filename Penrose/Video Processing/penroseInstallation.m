% Get desired webcam & set resolution
WEBCAM = 'C922 Pro Stream Webcam';
RESOLUTION = [1920, 1080];

%get reference information for calulating location on floor plan
METRICS = load("reference_metrics.mat");
REF_CENTER = METRICS.reference_center;
REF_AREA = METRICS.reference_area;
MAX_AREA = METRICS.maxArea;
MIN_AREA = METRICS.minArea;
MAX_DISTANCE = MAX_AREA - REF_AREA;
MIN_DISTANCE = REF_AREA - MIN_AREA;

% get penrose shapes
PENROSE = load("penrose_layers.mat");
LAYER = PENROSE.layer2;
PENTS = LAYER{1};
DIAMONDS = LAYER{2};
STARS = LAYER{3};
BOATS = LAYER{4};

% get penrose progressions
PROGRESSIONS = load("penrose_progressions.mat");
p_progression = PROGRESSIONS.p_progression;
d_progression = PROGRESSIONS.d_progression;
s_progression = PROGRESSIONS.s_progression;
b_progression = PROGRESSIONS.b_progression;

%Number of People in the Room
PEOPLE = 1;

%select the webcam 
cam = webcam(WEBCAM);

%build the people detectors
faceDetector = vision.CascadeObjectDetector('UpperBody');
peopleDetector = vision.PeopleDetector;

%set type of detector needed for project & webcam resolution
DETECTOR = peopleDetector;

% resolution preprocessing
MIDPOINT = RESOLUTION/2;

%OSC port opening -- IP changes periodically in Reaper
%                 -- port stays the same
LOCAL_IP_PORT = '10.18.159.140';
u = udp(LOCAL_IP_PORT, 8000);
fopen(u);

% Number of audio tracks, output channels
% output channels will be buses after the other channels
NUM_TRACKS = 150;
NUM_CHANNELS = 8; %plus LFE (+1 to last channel)
LFE = NUM_TRACKS + NUM_CHANNELS + 1;

%initialize audio in reaper to be muted & volume 0
% Master track set to zero volume
for i = 1:NUM_TRACKS
    message = "/track/" + i + "/mute";
    message = convertStringsToChars(message);
    oscsend(u, message, 'f', 0);

    %set sends equal to 0
    for j = 1:(NUM_CHANNELS+1)
        message1 = "/track/" + i + "/send/" + j + "/volume";
        message1 = convertStringsToChars(message1);
        oscsend(u, message1, 'f', 0);
    end
end

for i = 1:(NUM_CHANNELS+1)
    verb_channel = i + NUM_TRACKS;
    message = "/track/" + verb_channel + "/volume";
    message = convertStringsToChars(message);
    oscsend(u, message, 'f', .6)   
end

oscsend(u, '/play', 'i', 1)

%set stop time
STOP = 180;

%Set musical hyperparameters (firmuses)
GROUND_VALUES = [16.35, 32.7, 65.41, 130.81, 261.63, 130.81, 65.41, 32.70, 16.35];
last_ground = 0;

%start the progressions at the first chord
p_count = 1;
d_count = 1;
s_count = 1;
b_count = 1;

%keep track of ground changes
ground_changes = 0;

%initialize stop messages
stop_messages = cell(1,15);

%initialize figure for display
plotShapes(LAYER);
hold on;

fin = 1;

while(fin < STOP)
    disp('looping');
    
    frame = snapshot(cam);

    bboxes = step(DETECTOR, frame);
    disp("this is bboxes ");
    disp(bboxes);

    if isempty(bboxes)
        continue
    end

    spatial_coords = {};

    %note that max_distance and min_distance are the differences in the
    %sizes of the bboxes found at the extremes of the installation
    %perimeter
    %
    %the division by these parameters should normalize the sizes of bboxes
    %to the range [-1, 1], placing the y value in the range of our floor
    %plan
    sz = size(bboxes);
    
    h = findobj(figure(1), 'type', 'line');
    for i = 1:length(h)
        object = h(i);
        if object.Marker == '*'
        delete(object);
        end
    end

    for j = 1:sz(1)
        bbox = bboxes(j,:);
        area = bbox(3)*bbox(4);
        if area < MIN_AREA
            %I doubt people will be smaller than me significantly, so I
            %will use myself as the lower limit for bboxes
            continue
        elseif area > MAX_AREA
            %sets global parameter to a new limit if larger people are in
            %the room
            MAX_AREA = area;
        end
        coordinates = bbox2points(bbox);
        center = mean(coordinates);
        x = (center(1) - REF_CENTER(1))/(RESOLUTION(1)-REF_CENTER(1));
        pre_y = REF_AREA - area;
        if pre_y < 0
            y = pre_y/MAX_DISTANCE;
        elseif pre_y > 0
            y = pre_y/MIN_DISTANCE;
        end
        spatial_coords{j} = [x, y];
        figure(1); plot(x, y, 'r*'); hold on;
    end

    disp("this is spatial coords");
    disp(spatial_coords);
    
    % find which shape each spatial coordinate is in
    % shape tiggers determine how many note on events for this image, for
    % each shape (pents, diamonds, stars, boats]
    shape_triggers = [0, 0, 0, 0];
    shapes_found = 0;

    %pentagons first
    for p = 1:length(PENTS)
        pent = PENTS(p);
        [pentx, penty] = pent.getXY;
        for w = 1:length(spatial_coords)
            if isempty(spatial_coords{w})
                continue
            end
            curr_coords = spatial_coords{w};
            curr_x = curr_coords(1);
            curr_y = curr_coords(2);
            in_pent = inpolygon(curr_x, curr_y, pentx, penty);
            if in_pent == 1
                shape_triggers(1) = shape_triggers(1) + 1;
                shapes_found = shapes_found + 1;
            end
        end
        if shapes_found == length(spatial_coords)
            break
        end
    end
    
    if shapes_found < length(spatial_coords)
        %now diamonds
        for d = 1:length(DIAMONDS)
            diamond = DIAMONDS(d);
            [diamondx, diamondy] = diamond.getXY;
            for w = 1:length(spatial_coords)
                if isempty(spatial_coords{w})
                    continue
                end
                curr_coords = spatial_coords{w};
                curr_x = curr_coords(1);
                curr_y = curr_coords(2);
                in_pent = inpolygon(curr_x, curr_y, diamondx, diamondy);
                if in_pent == 1
                    shape_triggers(2) = shape_triggers(2) + 1;
                    shapes_found = shapes_found + 1;
                end
            end
            if shapes_found == length(spatial_coords)
                break
            end
        end
    end

    if shapes_found < length(spatial_coords)
        %now stars
        for s = 1:length(STARS)
            star = STARS(s);
            [starx, stary] = star.getXY;
            for w = 1:length(spatial_coords)
                if isempty(spatial_coords{w})
                    continue
                end
                curr_coords = spatial_coords{w};
                curr_x = curr_coords(1);
                curr_y = curr_coords(2);
                in_pent = inpolygon(curr_x, curr_y, starx, stary);
                if in_pent == 1
                    shape_triggers(3) = shape_triggers(3) + 1;
                    shapes_found = shapes_found + 1;
                end
            end
            if shapes_found == length(spatial_coords)
                break
            end
        end
    end

    if shapes_found < length(spatial_coords)
        %now boats
        for b = 1:length(BOATS)
            boat = BOATS(b);
            [boatx, boaty] = boat.getXY;
            for w = 1:length(spatial_coords)
                if isempty(spatial_coords{w})
                    continue
                end
                curr_coords = spatial_coords{w};
                curr_x = curr_coords(1);
                curr_y = curr_coords(2);
                in_pent = inpolygon(curr_x, curr_y, boatx, boaty);
                if in_pent == 1
                    shape_triggers(4) = shape_triggers(4) + 1;
                    shapes_found = shapes_found + 1;
                end
            end
            if shapes_found == length(spatial_coords)
                break
            end
        end
    end

    if shapes_found ~= length(spatial_coords)
        shape_triggers(1) = shape_triggers(1) + (shapes_found - length(spatial_coords));
    end

    ground_index = ceil(fin/(STOP/length(GROUND_VALUES)));
    disp("this is ground_index" + ground_index)
    ground = GROUND_VALUES(ground_index);

    num_pents = shape_triggers(1);
    num_diamonds = shape_triggers(2);
    num_stars = shape_triggers(3);
    num_boats = shape_triggers(4);

    disp("this is shape triggers ")
    disp(shape_triggers);
    disp("this is shapes found " + shapes_found);


    for i = 1:shapes_found
        if ~isempty(stop_messages{i})
            oscsend(u, stop_messages{i}, 'f', 0);
        end
    end
    if shapes_found > 0
        stop_messages = stop_messages(shapes_found:length(stop_messages));
    end
    
    for i = 1:num_pents
        pent_notes = p_progression(p_count);
        p_count = mod(p_count + 1, 6) + 1;
        
        for j = 1:length(pent_notes)
            note = pent_notes(j);
            if note*ground < 150
                out_channel = 9;
            else
                out_channel = randi([1,8]);
            end
            send_channel = (ground_index-1)*30 + note;
            message = "/track/" + send_channel + "/send/" + out_channel + "/volume";
            message = convertStringsToChars(message);
            oscsend(u, message, 'f', .6);
            stop_messages{length(stop_messages)+1} = message;
        end
    end

    for i = 1:num_diamonds
        d_notes = d_progression(d_count);
        d_count = mod(d_count + 1, 6) + 1;
        
        for j = 1:length(d_notes)
            note = d_notes(j);
            if note*ground < 150
                out_channel = 9;
            else
                out_channel = randi([1,8]);
            end
            send_channel = (ground_index-1)*30 + note;
            message = "/track/" + send_channel + "/send/" + out_channel + "/volume";
            message = convertStringsToChars(message);
            oscsend(u, message, 'f', .6);
            stop_messages{length(stop_messages)+1} = message;
        end
    end

     for i = 1:num_stars
        s_notes = s_progression(s_count);
        s_count = mod(s_count + 1, 6) + 1;
        
        for j = 1:length(s_notes)
            note = s_notes(j);
            if note*ground < 150
                out_channel = 9;
            else
                out_channel = randi([1,8]);
            end
            send_channel = (ground_index-1)*30 + note;
            message = "/track/" + send_channel + "/send/" + out_channel + "/volume";
            message = convertStringsToChars(message);
            oscsend(u, message, 'f', .6);
            stop_messages{length(stop_messages)+1} = message;
        end
     end

      for i = 1:num_boats
        b_notes = b_progression(b_count);
        b_count = mod(b_count + 1, 6) + 1;
        
        for j = 1:length(b_notes)
            note = b_notes(j);
            if note*ground < 150
                out_channel = 9;
            else
                out_channel = randi([1,8]);
            end
            send_channel = (ground_index-1)*30 + note;
            message = "/track/" + send_channel + "/send/" + out_channel + "/volume";
            message = convertStringsToChars(message);
            oscsend(u, message, 'f', .6);
            stop_messages{length(stop_messages)+1} = message;
        end
      end

    %set cleanup function for CTRL + C
    %cleanup = onCleanup(@()myCleanupFun());

    disp("this is stop messages")
    %disp(stop_messages)

    fin = fin + 1;

end

oscsend(u, '/stop', 'i', 1);

%function myCleanupFun()
    %oscsend(u, '/stop', 'i', 1);
%end


