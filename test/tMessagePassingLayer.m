classdef tMessagePassingLayer < matlab.unittest.TestCase
    % tMessagePassingLayer. Test for MessagePassingLayer
    properties
        MessagePassingLayer = @layer.MessagePassingLayer;
        NumFilters= 128;
        FilterSize = 9;
        RS
    end
    properties(TestParameter)
        Direction = {'topDown', 'bottomUp', 'leftRight', 'rightLeft'};
        ExpectedOut = iGetExpectedOutputs();
    end
     methods(TestMethodSetup)
        function setupRNGSeed(test)
            test.RS = rng(0);
        end
    end

    methods(TestMethodTeardown)
        function resetRNGSeed(test)
            rng(test.RS);
        end
    end
    methods(Test,ParameterCombination = 'sequential')
        function testConstruction(test,Direction)
            layer = test.MessagePassingLayer(test.FilterSize,test.NumFilters,Direction,'Name',strcat('message_passing_',Direction));

            % Verifying the layer properties.
            test.verifyEqual(layer.Name,strcat('message_passing_',Direction))
            test.verifyEqual(layer.NumFilters,test.NumFilters);
            test.verifyEqual(layer.FilterSize,test.FilterSize);
            test.verifyEqual(layer.Type,strcat("Message passing " , Direction , " block"));
            test.verifyClass(layer.MessagePassingBlock,'dlnetwork')
            test.verifyEqual(numel(layer.MessagePassingBlock.Layers),2);
            test.verifyFalse(layer.MessagePassingBlock.Initialized);
            % Verifying the properties of layers inside
            % MessagePassingBlock.            
            test.verifyClass(layer.MessagePassingBlock.Layers(1),'nnet.cnn.layer.Convolution2DLayer');
            test.verifyEqual(layer.MessagePassingBlock.Layers(1).Name,'conv1');
            
            if ismember(Direction,{'topDown', 'bottomUp'})
                test.verifyEqual(layer.MessagePassingBlock.Layers(1).FilterSize,[1 test.FilterSize]);
            else
                test.verifyEqual(layer.MessagePassingBlock.Layers(1).FilterSize,[test.FilterSize 1]);
            end
            
            test.verifyEqual(layer.MessagePassingBlock.Layers(1).NumFilters, test.NumFilters);
            test.verifyEqual(layer.MessagePassingBlock.Layers(1).PaddingMode,'same');            
            test.verifyClass(layer.MessagePassingBlock.Layers(2),'nnet.cnn.layer.ReLULayer');
            test.verifyEqual(layer.MessagePassingBlock.Layers(2).Name,'relu1');            
        end        
        function testPredict(test,Direction,ExpectedOut)
            numFilters = 2;
            layer = test.MessagePassingLayer(test.FilterSize,numFilters,Direction);
            %constructing an initialized dlnetwork the messagePassingBlock
            %to call predict and exercising predict.
            dlnet = dlnetwork([imageInputLayer([3 3 3],'normalization','none') ; layer.MessagePassingBlock.Layers]);
            input = dlarray(ones(2,2,3),'SSC');
            out = dlnet.predict(input);
            
            test.verifyEqual(size(out),[2 2 numFilters]);
            test.verifyEqual(ExpectedOut,ExpectedOut)
        end
    end
end
function out = iGetExpectedOutputs()
td(:,:,1) = [0.5833 0.6376; 0.5833 0.6376];
td(:,:,2) = [0 0 ; 0 0 ];
bu(:,:,1) = [0.5833 0.6376; 0.5833 0.6376];
bu(:,:,2) = [0 0 ; 0 0 ];
lr(:,:,1) = [0.5833 0.5833; 0.6376 0.6376];
lr(:,:,2) = [0 0; 0 0];
rl(:,:,1) = [0.5833 0.5833; 0.6376 0.6376];
rl(:,:,2) = [0 0;0 0];

out = struct('topDownExp',td, 'bottomUpExp',bu, 'leftRightExp',lr, 'rightLeftExp',rl);
end
