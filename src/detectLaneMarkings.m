function detections = detectLaneMarkings(net, data, params, executionEnvironment, NameValueArgs)
% detections = detectLaneMarkings(net, image, params, executionEnvironment)
% runs prediction on a pre-trained SCNN network.
%
% Inputs:
% -------
% net                  - Pretrained SCNN dlnetwork.
% data                 - Input data must be a single RGB image of size
%                        HxWx3 or an array of RGB images of size HxWx3xB,
%                        where H is the height, W is the width and B is the
%                        number of images.
% params               - Parameters required to run inference on SCNN
%                        created using
%                        helper.createSCNNDetectionParameters.                   
% executionEnvironment - Environment to run predictions on. Specify cpu,
%                        gpu, or auto.
% 
% detections = detectLaneMarkings(..., Name, Value) specifies the optional
% name-value pair argument as described below.
% 
% 'FitPolyLine'        - Specify the value true or false. If true then
%                        second order polynomials are fit to the detections
%                        to make them smooth else raw detections are
%                        returned.
%
%                        Default: true 
%                        
%                        
% Output:
% -------
% detections           - Returns a cell array of M-by-N, where M is the
%                        number of images in a batch and N is the number of
%                        lanes detected. Each cell contains a P-by-2 array
%                        of pixel coordinates of the detected lane
%                        markings, where P is the number of points and 2
%                        colums are X and Y values of their respective
%                        pixel coordinates.

% Copyright 2021 The MathWorks, Inc.

% Parse input arguments.
arguments
    net
    data
    params
    executionEnvironment
    NameValueArgs.FitPolyLine = true;
end
fitPolyLine = NameValueArgs.FitPolyLine;

% Get the input image size.
inputImageSize = size(data);

% Resize the image to the input size of the network.
resizedImage = imresize(data, params.networkInputSize);

% Rescale the pixels in the range [0,1].
resizedImage = im2single(resizedImage);

% Convert the resized image to dlarray and gpuArray if specified.
if canUseGPU && ~(strcmp(executionEnvironment,"cpu"))
    resizedImage = gpuArray(dlarray(resizedImage,'SSCB'));
else
    resizedImage = dlarray(resizedImage,'SSCB');
end

% Predict the output.
[laneMask, confidence] = predict(net, resizedImage);

% Process the predictions to output probability map and confidence scores.
[laneMask, confidence] = helper.processPredictions(laneMask, confidence, params.threshold);

% Extract lane marking coordinates from the probability map and confidence
% scores.
detections = helper.generateLines(laneMask, confidence, inputImageSize, params, fitPolyLine);

end
