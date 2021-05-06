classdef(SharedTestFixtures = {DownloadSCNNLaneDetectionFixture}) tload < matlab.unittest.TestCase
    % Test for loading the downloaded model.
    
    % Copyright 2021 The MathWorks, Inc.
    
    % The shared test fixture DownloadSCNNLaneDetectionFixture calls
    % downloadSCNNLaneDetection. Here we check that the properties of
    % downloaded model.
    
    properties        
        DataDir = fullfile(getRepoRoot(),'model');        
    end
    
    methods(Test)
        function verifyModelAndFields(test)
            % Test point to verify the fields of the downloaded models are
            % as expected.
                                    
            loadedModel = load(fullfile(test.DataDir,'scnn-culane.mat'));
             
            test.verifyClass(loadedModel.net,'dlnetwork');
            test.verifyEqual(numel(loadedModel.net.Layers),62);
            test.verifyEqual(size(loadedModel.net.Connections),[61 2])
            test.verifyEqual(loadedModel.net.InputNames,{'input'});
            test.verifyEqual(loadedModel.net.OutputNames,{'layer2_2','fc_3'});
        end        
    end
end