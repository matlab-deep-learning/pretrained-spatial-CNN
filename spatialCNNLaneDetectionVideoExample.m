%% Lane Detection Using Spatial-CNN Network in Driving Scene
% The following code demonstrates running lane detection on a pre-trained
% SCNN network on a driving scene.

%% Prerequisites
% To run this example you need the following prerequisites - 
% * MATLAB (R2021a or later).
% * Deep Learning Toolbox.
% * Automated Driving Toolbox (required to load the video).
% * Pretrained Spatial-CNN network (download instructions below).

%% Add path to the source directory
addpath('src');

%% Download Pre-trained Network
model = helper.downloadSCNNLaneDetection;
net = model.net;

%% Specify Detection Parameters
% Use the function helper.createSCNNDetectionParameters to specify the
% parameters required for lane detection.
params = helper.createSCNNDetectionParameters;

% Specify the mini batch size as 8. Increase this value to speed up
% detection time.
miniBatchSize  = 8;

% Specify the executionEnvironment as either "cpu", "gpu", or "auto".
executionEnvironment = "auto";

%% Detect in Video
% Read the video.
v = VideoReader('caltech_washington1.avi');

% Store the video start time.
videoStartTime = v.CurrentTime;

% Detect using the detectLaneMarkingVideo function provided as helper
% function below.
laneMarkings = detectLaneMarkingVideo(net, v, params, miniBatchSize, executionEnvironment);

% Plot detections in video and save result.
helper.plotLanesVideo(v, laneMarkings, videoStartTime);


%% Helper function to Detect in Video
function laneMarkings = detectLaneMarkingVideo(net, v, params, miniBatchSize, executionEnvironment)
% Detect lane markings in a video by reading frames in batches.
laneMarkings = {};
numBatches = ceil(v.NumFrames/miniBatchSize);
for batch = 1:numBatches
    firstFrameIdx = miniBatchSize*batch-(miniBatchSize-1);
    if batch ~= numBatches
        lastFrameIdx = miniBatchSize*batch;
    else
        lastFrameIdx = v.NumFrames;
    end
    % Read batch of frames.
    frames = read(v, [firstFrameIdx, lastFrameIdx]);
    
    % Detect lanes using the function detectLaneMarking.
    detections = detectLaneMarkings(net, frames, params, executionEnvironment);
    
    % Append the detections.
    laneMarkings = [laneMarkings; detections];
    
    % Print detection progress.
    fprintf("Detected %d frames out of %d frames.\n",lastFrameIdx,v.NumFrames);
end
end

% Copyright 2021 The MathWorks, Inc.
