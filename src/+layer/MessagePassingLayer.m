classdef MessagePassingLayer < nnet.layer.Layer
    % MessagePassingLayer  Message Passing layer that applies
    %                      slice-by-slice convolution and relu within the
    %                      feature map.
    %
    %   To create a MessagePassingLayer, use:
    %   layer = MessagePassingLayer(filterSize, numFilters, direction, ...
    %             'Name', 'msgpassinglayer');
    %
    %   Inputs:
    %   -------
    %   filterSize - Specify a positive integer for the filter size of the
    %                slice-by-slice convolution operation.
    %
    %   numFilters - Specify a positive integer for the number of filters
    %                in the convolution layer.
    %
    %   direction  - Specify a string or character array for the direction
    %                of the slice-by-slice convolution operation. The valid
    %                value are 'topDown', 'bottomUp', 'leftRight', and
    %                'rightLeft'.
    %
    %   layer = MessagePassingLayer(__, 'PARAM', VAL) specifies optional
    %   parameter name/value pairs for creating the layer:
    % 
    %   'Name'     - A string or character array that specifies the name
    %                for the layer.
    %
    %                Default : ''
    %
    %   Example:
    %   --------
    %   Create a top down message passing layer with filtersize of 9 and
    %   128 number of filters.
    %   l = MessagePassingLayer(9, 128, 'topDown', 'Name', 'top-down');
    
    %   Copyright 2021 The MathWorks, Inc.

    properties
        % NumFilters in message passing.
        NumFilters
        
        % Filter size of message passing block.
        FilterSize
        
        % Direction of message passing.
        Direction
    end
    
    properties (Learnable)
        % Layer learnable parameters
        
        MessagePassingBlock
    end
    
    methods
        function layer = MessagePassingLayer(filterSize,numFilters,direction,NameValueArgs)
            % Creates a conv+relu block with the specified convolution
            % filters, filter size and direction.
    
            % Parse input arguments.
            arguments
                filterSize {mustBeInteger,mustBePositive}
                numFilters {mustBeInteger,mustBePositive}
                direction {mustBeTextScalar}
                NameValueArgs.Name = ''
            end
            
            name = NameValueArgs.Name;
    
            % Set layer name.
            layer.Name = name;
            layer.NumFilters = numFilters;
            layer.FilterSize = filterSize;
            layer.Direction = iCheckAndReturnValidDirection(direction);
            
    
            % Set layer description.
            description = "Message passing " + layer.Direction + " block with num filters "+ layer.NumFilters+" and filter size "+layer.FilterSize;
            layer.Description = description;
            
            % Set layer type.
            layer.Type = "Message passing " + layer.Direction + " block";
    
            % Define nested layer graph.
            if strcmp(layer.Direction,'topDown') || strcmp(layer.Direction,'bottomUp')
                layers = [
                    convolution2dLayer([1,filterSize],numFilters,'Padding',"same",'Name','conv1',"BiasLearnRateFactor",0)
                    reluLayer('Name','relu1')
                    ];
            else
                layers = [
                    convolution2dLayer([filterSize,1],numFilters,'Padding',"same",'Name','conv1',"BiasLearnRateFactor",0)
                    reluLayer('Name','relu1')
                    ];
            end
    
            lgraph = layerGraph(layers);
    
            % Convert to dlnetwork.
            dlnet = dlnetwork(lgraph,'Initialize',false);
    
            % Set Network property.
            layer.MessagePassingBlock = dlnet;
        end
        
        function Z = predict(layer, X)
            % Forward input data through the layer at prediction time and
            % output the result.
            %
            % Inputs:
            %         layer - Layer to forward propagate through
            %         X     - Input data
            % Outputs:
            %         Z - Output of layer forward function
                       
            % Convert input data to formatted dlarray.
            X = dlarray(X,'SSCB');
            dlnet = layer.MessagePassingBlock;
            fh = str2func(layer.Direction);
            
            % Process message passing block.
            Z = fh(dlnet,X);
            Z = stripdims(Z);
        end
    end
end

function value = iCheckAndReturnValidDirection(value)
validateattributes(value, {'char','string'},{},'','Direction');
value = validatestring(value, {'topDown', 'bottomUp', 'leftRight', 'rightLeft'},'','Direction');
end

function block = topDown(net,block)
% Slice along the height.
sliceDim = 1;
for i = 2:size(block,sliceDim)
    z = predict(net,block(i-1,:,:,:));
    block(i,:,:,:) = block(i,:,:,:) + z;
end
end

function block = bottomUp(net,block)
% Slice along the height.
sliceDim = 1;
for i = size(block,sliceDim)-1:-1:1
    z = predict(net,block(i+1,:,:,:));
    block(i,:,:,:) = block(i,:,:,:) + z;
end
end

function block = leftRight(net,block)
% Slice along the width.
sliceDim = 2;
for i = 2:size(block,sliceDim)
    z = predict(net,block(:,i-1,:,:));
    block(:,i,:,:) = block(:,i,:,:) + z;
end
end

function block = rightLeft(net,block)
% Slice along the width.
sliceDim = 2;
for i = size(block,sliceDim)-1:-1:1
    z = predict(net,block(:,i+1,:,:));
    block(:,i,:,:) = block(:,i,:,:) + z;
end
end
