classdef DownloadSCNNLaneDetectionFixture < matlab.unittest.fixtures.Fixture
    % DownloadSCNNLaneDetectionFixture   A fixture for calling 
    % downloadDownloadSCNNLaneDetectionFixture if necessary. This is to 
    % ensure that this function is only called once and only when tests 
    % need it. It also provides a teardown to return the test environment
    % to the expected state before testing.
    
    % Copyright 2021 The MathWorks, Inc
    
    properties(Constant)
        SCNNDataDir = fullfile(getRepoRoot(),'model')
    end
    
    properties
        SCNNExist (1,1) logical        
    end
    
    methods
        function setup(this) 
            import matlab.unittest.fixtures.CurrentFolderFixture;
            this.applyFixture(CurrentFolderFixture ...
                (getRepoRoot()));
            
            this.SCNNExist = exist(fullfile(this.SCNNDataDir,'scnn-culane.mat'),'file')==2;
            
            % Call this in eval to capture and drop any standard output
            % that we don't want polluting the test logs.
            if ~this.SCNNExist
            	evalc('helper.downloadSCNNLaneDetection();');
            end       
        end
        
        function teardown(this)
            if this.SCNNExist
            	delete(fullfile(this.SCNNDataDir,'model','scnn-culane.mat'));
            end              
        end
    end
end
