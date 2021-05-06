classdef(SharedTestFixtures = {DownloadSCNNLaneDetectionFixture}) tdownloadSCNNLaneDetection < matlab.unittest.TestCase
    % Test for downloadSCNNLaneDetection
    
    % Copyright 2021 The MathWorks, Inc.
    
    % The shared test fixture DownloadSCNNLaneDetectionFixture calls
    % downloadSCNNLaneDetection. Here we check that the downloaded files
    % exists in the appropriate location.
    
    properties        
        DataDir = fullfile(getRepoRoot(),'model');
    end
    
    methods(Test)
        function verifyDownloadedFilesExist(test)
            dataFileName = 'scnn-culane.mat';
            test.verifyTrue(isequal(exist(fullfile(test.DataDir,dataFileName),'file'),2));
        end
    end
end
