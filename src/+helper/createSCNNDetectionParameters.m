function params = createSCNNDetectionParameters()
% createSCNNDetectionParameters creates parameters required for detection.

% Copyright 2021 The MathWorks, Inc.

% Specify these parameters for detection -
% * Set the threshold as 0.5. Detections with confidence score less than
% threshold are ignored.
% * Set the networkInputSize as [288,800]. 
params.threshold = 0.5;
params.networkInputSize = [288,800];

end
