% plsr(faces, 'LBP', {k1,k2,k3,k4,k5})

function MAE = plsr( bdd, feature, folds )

% number of folds
numFolds = length( folds );

% arrays of input and label vector for each fold
kX = cell( numFolds, 1 );
kY = cell( numFolds, 1 );

% read features and labels for each sample of each fold
for kk = 1:numFolds
    % Create a matrix(sizeFold, sizeFeature)
    kX{ kk } = zeros(length( folds{ kk } ), length( bdd{1}.( feature ) ) );

    % Create empty matrix(sizeFold, 1)
    kY{ kk } = zeros(length( folds{ kk } ), 1);

    % For the current fold
    for i = 1:length( folds{ kk } )
        kX{ kk }(i,:) = bdd{ folds{ kk }(i) }.( feature );      
        kY{ kk }(i) = str2double( bdd{ folds{ kk }(i) }.age );
    end
end

assignin('base', 'kX', kX);
assignin('base', 'kY', kY);

    % 1/ GLOBAL PLSR CONSTRUCTION
    GLOBAL_betas = [];
    
    % 2/ LOCAL PLSR (SECTIONS) CONSTRUCTION
    LOCALS_betas = [];
    
    % 3/ Y1 = DRAFT PREDICTION BY GLOBAL PLSR
    %Y1
    % 4/ Y2 = LOCAL PREDICTION BY LOCAL PLSR ASSOCIATED TO SECTIONS

end

