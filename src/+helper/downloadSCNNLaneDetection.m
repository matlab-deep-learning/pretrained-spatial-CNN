function model = downloadSCNNLaneDetection()
% The downloadSCNNLaneDetection function loads a pretrained
% SCNN network.
%
% Copyright 2021 The MathWorks, Inc.

dataPath = 'model';
modelName = 'scnn-culane';
netFileFullPath = fullfile(dataPath, modelName);

% Add the extensions to filename.
netMatFileFull = [netFileFullPath,'.mat'];
netZipFileFull = [netFileFullPath,'.zip'];

if ~exist(netZipFileFull,'file')
    fprintf(['Downloading pretrained ', modelName ,' network.\n']);
    fprintf('This can take several minutes to download...\n');
    url = 'https://ssd.mathworks.com/supportfiles/vision/deeplearning/models/SpatialCNN/SCNN.zip';
    websave (netFileFullPath,url);
    unzip(netZipFileFull, dataPath);
    path = fullfile(netMatFileFull);
    model = load(path);
else
    if ~exist(netMatFileFull,'file')
        fprintf('Pretrained SCNN-CULane network already exists.\n\n');
        unzip(netZipFileFull, dataPath);
    end
    path = fullfile(netMatFileFull);
    model = load(path);
end
end
