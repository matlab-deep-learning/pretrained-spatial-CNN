classdef(SharedTestFixtures = {DownloadSCNNLaneDetectionFixture}) tPretrainedSCNNLaneDetection < matlab.unittest.TestCase
    % Test for tPretrainedSCNNLaneDetection
    
    % Copyright 2021 The MathWorks, Inc.
    
    % The shared test fixture downloads the model. Here we check the
    % inference on the pretrained model.
    properties        
        RepoRoot = getRepoRoot;
        ModelName = 'scnn-culane.mat';
    end
    
    methods(Test)
        function exerciseDetection(test)            
            model = load(fullfile(test.RepoRoot,'model',test.ModelName));
            image = imread(fullfile(test.RepoRoot,"images","testImage.jpg"));
            executionEnvironment = "auto";
            params = helper.createSCNNDetectionParameters;
            laneMarkings = detectLaneMarkings(model.net, image, params, executionEnvironment);         
                           
            % verifying output class
            test.verifyClass(laneMarkings,'cell');
            
            % verifying size of output from detectLaneMarkings.
            test.verifyEqual(size(laneMarkings{1}),[322 2]);
            test.verifyEqual(size(laneMarkings{2}),[560 2]);
            test.verifyEqual(size(laneMarkings{3}),[556 2]);
            test.verifyEqual(size(laneMarkings{4}),[0 0]);
        end      
    end
end
