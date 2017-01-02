%CROSSVALIDATEDREGRESSION applies regression using a k-fold cross-validation scheme
% [MAE, kAE] = CROSSVALIDATEDREGRESSION( DATA, FEATURENAME, TARGETNAME,
% NCOMP, KFOLDS ) returns the mean average error (MAE) of the regression
% and the absolute error of each fold (kAE) after applying a cross-validation
% with folds defined by the indices of KFOLDS to predict the field TARGETNAME 
% of the cellarray DATA, using the features stored in the field FEATURENAME.
% The regressor is PLSREGRESS with NCOMP PLS components.
%
% Example:
%         [MAE, kAE] = crossValidatedRegression( faces, 'LBP', 'age', 30, {k1, k2, k3, k4, k5} );  
%
function [MAE, kAE, reg] = crossValidatedRegression( data, featureName, targetName, NCOMP, kFolds )

% number of folds
numFolds = length( kFolds );

% arrays of input and label vector for each fold
kX = cell( numFolds, 1 );
kY = cell( numFolds, 1 );

% read features and labels for each sample of each fold
for kk = 1:numFolds

    % On crée une matrice de taille du fold par taille de la feature
    % Ex: Taille de k1 par taille de LBP
    kX{ kk } = zeros(length( kFolds{ kk } ), length( data{1}.( featureName ) ) );
    
    % On crée une matrice vide de la taille du fold
    % Ex: Taille de k1
    kY{ kk } = zeros(length( kFolds{ kk } ), 1);

    % on parcout le fold courrant
    for i = 1:length( kFolds{ kk } )
        kX{ kk }(i,:) = data{ kFolds{ kk }(i) }.( featureName );      
        kY{ kk }(i) = str2double( data{ kFolds{ kk }(i) }.( targetName ) );
    end
    
end

% kX contient pour chaque fold 
% une ligne fait reference a un individu
% Les colones sont les features
% save('mat/reg/KX', 'kX');

% kY contient pour chaque fold
% une ligne contient l'age réel de l'individu
% save('mat/reg/KY', 'kY');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TEST 

kMAE = cell( numFolds, 1 );
kAE = cell( numFolds, 1 );
reg = cell(1,5);

betas = [];
for kk=1:numFolds

    X = [];
    Y = [];
    for jj=1:numFolds
        if jj ~= kk
            X = vertcat( X, kX{ jj } );
            Y = vertcat( Y, kY{ jj } );
        end
    end
    
    %[kXL,kYL,kXS,kYS,kBETA] = plsregress( X, Y );
    [kXL,kYL,kXS,kYS,kBETA] = plsregress( X, Y, NCOMP );
    
    
    %save('mat/kXL', 'kXL');
    %save('mat/kYL', 'kYL');
    %save('mat/kXS', 'kXS');
    %save('mat/kYS', 'kYS');
    %save('mat/kBETA', 'kBETA');
    
    A = ones(length( kFolds{ kk } ), 1);
    
    kRegression = [A kX{ kk }] * kBETA;
    betas = [betas kBETA];
    kRegressionT = kRegression.';
    
    reg{1, kk} = kRegressionT;


    %% Mean Average Error
    kMAE{ kk } = sum( abs(kY{ kk }-kRegression ) ) / length( kFolds{kk} ); 

    %% Absolute error
    kAE{ kk } = abs( kY{ kk } - kRegression );
    % uncomment next line to store error with sign
    %kAE{ kk } = kY{ kk } - kRegression; 

end

%save('mat/reg/reg', 'reg');
%save('mat/reg/kAE','kAE');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOTAL MEAN AVERAGE ERROR
MAE = 0;

for kk=1:numFolds
    MAE = MAE + kMAE{ kk };
end

MAE = MAE / numFolds;
betas


