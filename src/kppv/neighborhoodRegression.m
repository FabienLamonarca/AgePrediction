% This algorithm separate database in 5 segments
% Segment 1 will be used like training set and 4 others will be used as
% learning set
% Foreach testing picture we determine "neighborNumber" of Nearest Neighbor
% in the training set
% Those will be represent a sub-training set, we do a PLS regressor on it
% and estimate the value of the picture.

% Use like this:
% neighborhoodRegression(faces, 'LBP', 'age', 30, {k1, k2, k3, k4, k5}, 20);

% MAE = Mean Age Error

function [ MAE, kAE ] = neighborhoodRegression( data, featureName, targetName, NCOMP, kFolds, neighborNumber )

    % number of folds
    numFolds = length( kFolds );

    % arrays of input and label vector for each fold
    kX = cell( numFolds, 1 );
    kY = cell( numFolds, 1 );

    % read features and labels for each sample of each fold
    for kk = 1:numFolds

        % Create a matrix(sizeFold, sizeFeature)
        kX{ kk } = zeros(length( kFolds{ kk } ), length( data{1}.( featureName ) ) );

        % Create empty matrix(sizeFold, 1)
        kY{ kk } = zeros(length( kFolds{ kk } ), 1);

        % For the current fold
        for i = 1:length( kFolds{ kk } )
            kX{ kk }(i,:) = data{ kFolds{ kk }(i) }.( featureName );      
            kY{ kk }(i) = str2double( data{ kFolds{ kk }(i) }.( targetName ) );
        end

    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % FEATURE NORMALIZATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % assignin('base', 'kX', kX);
    
    for i = 1:numFolds % Foreach fold
        fold = kX{i,1};
        
        for j = 1:size(fold,2) % Foreach fold column
            x_min = min(fold(:,j));
            x_max = max(fold(:,j));
            if x_min ~= x_max
                % Foreach image : Normalize
                for l = 1:size(fold,1)
                    xi = kX{i,1}(l,j);
                    kX{i,1}(l,j) = (xi - x_min)/(x_max - x_min);
                end
            end
        end
    end
    % assignin('base', 'kX_normalized', kX);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %   CROSS VALIDATION    %
    %%%%%%%%%%%%%%%%%%%%%%%%%        

    % Foreach testing set
    reg = [];
    for kk = 1:numFolds
        X = [];
        Y = [];
        T = []; % Test
        TY = []; % Test label
        
        % Creation of sets : training(X,Y) & testing(T)
        for jj = 1:numFolds    
            if jj ~= kk
                X = vertcat( X, kX{ jj } );
                Y = vertcat( Y, kY{ jj } );
            elseif jj == kk
                T = kX{jj};
                TY = kY{jj};
            end
        end
        
        % Foreach testing element
        % We looking for its 'neighborNumber' neighbors
        % And we do a PLS regressor on them
        for ti = 1:size(T)
           % X = training set
           % T = Testing set
           [nX, nY] = computeNeighbor(T(ti, :), X, Y, neighborNumber);
           
           % Learning on neighbor
           [kXL,kYL,kXS,kYS,kBETA] = plsregress( nX, nY, NCOMP );
           
           age = [1];
           nReg = [age T(ti,:)] * kBETA;
           reg = vertcat(reg, [nReg TY(ti,1)]);
           
        end
    end 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MEAN AGE ERROR CALCULATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Regression ended
    z = zeros(size(reg,1), 1);
    reg = [reg z];
    
    for i = 1:size(reg,1)
       reg(i, 3) = abs(reg(i, 2) - reg(i, 1)); 
    end
    
    MAE = mean(reg(:,3))
    %assignin('base', 'reg', reg);
end

