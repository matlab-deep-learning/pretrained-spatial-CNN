%% Lane Detection Using Spatial-CNN Network
% The following code demonstrates running lane detection on a pre-trained SCNN 
% network, trained on CULane dataset.

%% Prerequisites
% To run this example you need the following prerequisites - 
% * MATLAB (R2021a or later).
% * Deep Learning Toolbox. 
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

% Specify the executionEnvironment as either "cpu", "gpu", or "auto".
executionEnvironment = "auto";

%% Detect on an Image
% Read the test image.
path = fullfile("images","testImage.jpg");
image = imread(path);

% Call detectLaneMarkings to detect the lane markings.
laneMarkings = detectLaneMarkings(net, image, params, executionEnvironment);

% Visualize the detected lanes.
fig = figure;
helper.plotLanes(fig, image, laneMarkings);

% Copyright 2021 The MathWorks, Inc.
