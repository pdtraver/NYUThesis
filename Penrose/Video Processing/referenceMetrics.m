ref_bboxes = load('reference_bboxes.mat');
ref_frames = load('reference_frames.mat');

ref_bboxes = struct2cell(ref_bboxes);
ref_frames = struct2cell(ref_frames);

ref_bboxes = ref_bboxes{1};
ref_frames = ref_frames{1};

center_point = ref_bboxes{1};
reference_center = [center_point(1,1)+center_point(1,3)/2, center_point(1,2)+center_point(1,4)/2];
reference_area = center_point(3)*center_point(4);

maxArea = 0;
minArea = inf;

for i = 1:length(ref_bboxes)
    bbox = ref_bboxes{i};
    area = bbox(3)*bbox(4);
    if area > maxArea;
        maxArea = area;
    end
    if area < minArea
        minArea = area;
    end
end

save("reference_metrics.mat", "reference_center", "reference_area", "maxArea", "minArea");