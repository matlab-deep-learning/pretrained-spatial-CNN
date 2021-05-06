function plotLanesVideo(video, detections, startTime)
% The function plotLanesVideo plots the lane coordinates on the video
% frames and saves the ouput video. The maximum number of lanes that can be
% marked are 4.

% Copyright 2021 The MathWorks, Inc.

% Reset the current time to start time.
video.CurrentTime = startTime;

frameIdx = 1;
[~,videoName,~] = fileparts(video.Name);
filename = strcat(videoName,"_detected");
savepath = fullfile(pwd, filename);

% Initialize lane colours.
colors = ["red", "green", "blue", "yellow"];

% Create output video object.
outVideo = VideoWriter(savepath);
outVideo.FrameRate = video.FrameRate;
open(outVideo);

while video.hasFrame
    frame = readFrame(video);
    for i=1:size(detections,2)
        if ~isempty(detections{frameIdx,i})
            frame = insertMarker(frame, detections{frameIdx,i}(:,1:2),'o','Color',colors(i),'Size',5);
        end
    end
    writeVideo(outVideo,frame);
    frameIdx = frameIdx+1;
end
close(outVideo);
end
