% runTests   The test running script to be called by the CI system.

% Copyright 2021 The MathWorks, Inc.

% Add test tools to the path.
cd ./../
addpath('test/tools/');
addpath('src');
teardown = @() rmpath('src','test/tools');

suite = testsuite('Name','t*','IncludeSubfolders',true);
runner = matlab.unittest.TestRunner.withTextOutput;
resultsDir = fullfile('..','artifacts','test_results');
if exist(resultsDir,'dir')~=7
  mkdir(resultsDir);
end

resultsOutputFile = fullfile(resultsDir,'results.xml');
testresultsPlugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat(resultsOutputFile);
warningsPlugin = matlab.unittest.plugins.FailOnWarningsPlugin();
runner.addPlugin(testresultsPlugin);
runner.addPlugin(warningsPlugin);
tr = runner.run(suite);
teardown();
passed = all([tr.Passed]);
isCIJob = getenv('GITLAB_CI_JOB');
if(~isempty(isCIJob) && isCIJob=='1')
    % only run exit code in CI jobs
    exitCode = 0;
    if ~passed
        exitCode = 1;
    end
    exit(exitCode);
end
