function [probMap, confidence] = processPredictions(predictions, confidence, threshold)
% The function processPredictions applies post-processing to the
% predictions output by the SCNN network.
% The function returns the probability map and the confidence score of the
% detections.
% 
% Copyright 2021 The MathWorks, Inc.

if ~strcmp(dims(confidence),'CB')
    tmp = predictions;
    predictions = confidence;
    confidence = tmp;
end
    
% Apply a softmax to the predictions.
probMap = softmax(predictions);

% Extract and gather te predcitions.
probMap = gather(extractdata(probMap));
confidence = gather(extractdata(confidence));

% Only consider the confidence values that are greater than threshold.
confidence(confidence>threshold) = 1;
confidence(confidence<=threshold) = 0;
end
