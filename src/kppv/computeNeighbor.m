function [X, Y] = computeNeighbor( test, trainX, trainY, neighborNumber )
% Compute N neighbor of 'test' element in 'train' list
% Where N = neighborNumber
    ladder = zeros(neighborNumber, 3);
    % Col 1 = ID in trainX
    % Col 2 = DISTANCE from test
    % Col 3 = REAL AGE from trainY
    
    %%%%%%%%%%%%%%%%%%%
    % Naive algorithm %
    %%%%%%%%%%%%%%%%%%%
    
    % First step
    for i = 1 : neighborNumber
       d = dist(test, trainX(i, :));
       ladder(i, 1) = i;
       ladder(i, 2) = d;
       ladder(i, 3) = trainY(i,1);
    end
    
    % Le point le plus eloigné
    max_dist = max(ladder(:,2));
        
    % Second step
    for i = neighborNumber+1 : size(trainX, 1)
        d = dist(test, trainX(i, :));
        
        if d < max_dist
            for j = 1:neighborNumber
               if ladder(j, 2) == max_dist
                   ladder(j, 1) = i;
                   ladder(j, 2) = d;
                   ladder(j, 3) = trainY(i,1);
                   max_dist = max(ladder(:,2));
                   break
               end
            end
        end
    end
    
    % Creation of neighbor set
    X = zeros(neighborNumber, size(trainX,2));
    for i = 1:neighborNumber
        id = ladder(i, 1);
        X(i, :) = trainX(id, :); 
    end
    
    Y = zeros(neighborNumber, 1);
    for i = 1:neighborNumber
        id = ladder(i, 3);
        Y(i, :) = trainY(id, :); 
    end
    
    %assignin('base', 'X', X);
    %assignin('base', 'Y', Y);
    %assignin('base', 'ladder', ladder);
    %assignin('base', 'test', test);
    %assignin('base', 'train', train);
end

