function plotLanes(f, image, detections)
% The function plotLanes plots the lane coordinates as lines on the
% image. The maximum number of lanes that can be marked are 4.

% Copyright 2021 The MathWorks, Inc.

figure(f);
clf;

% Show the image.
imshow(image);

% Initialize lane colours.
colors = ["red", "green", "blue", "yellow"];
% Add lane coordinates to the image.
hold on;
for i=1:size(detections,2)
    if ~isempty(detections{1,i})
        plot(detections{1,i}(:,1),detections{1,i}(:,2),'LineWidth',10,'Color',colors(i));
    end
end
hold off;
end
