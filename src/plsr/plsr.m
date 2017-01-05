% plsr(faces, 'LBP', {k1,k2,k3,k4,k5})

function MAE = plsr( bdd, feature, folds )
%% INIT
profile on
sections = [22 37 68];
numFolds = length( folds );



%% arrays of input and label vector for each fold
kX = cell( numFolds, 1 );
kY = cell( numFolds, 1 );

%% read features and labels for each sample of each fold
for kk = 1:numFolds
    %% Create a matrix(sizeFold, sizeFeature)
    kX{ kk } = zeros(length( folds{ kk } ), length( bdd{1}.( feature ) ) );

    %% Create empty matrix(sizeFold, 1)
    kY{ kk } = zeros(length( folds{ kk } ), 1);

    %% For the current fold
    for i = 1:length( folds{ kk } )
        kX{ kk }(i,:) = bdd{ folds{ kk }(i) }.( feature );      
        kY{ kk }(i) = str2double( bdd{ folds{ kk }(i) }.age );
    end
end 

%% DEBUG

%assignin('base', 'kX', kX); % kX represent our 5 sets features
%assignin('base', 'kY', kY); % kY represent our 5 sets ages


%% FOREACH FOLD
for kk = 1:numFolds
    X = [];
    Y = [];
    T = []; % Test
    TY = []; % Test label

    % Creation of sets : training(X,Y) & testing(T, TY)
    for jj = 1:numFolds    
        if jj ~= kk
            X = vertcat( X, kX{ jj } );
            Y = vertcat( Y, kY{ jj } );
        elseif jj == kk
            T = kX{jj};
            TY = kY{jj};
        end
    end
    
    %% DEBUG 
    assignin('base', 'X', X);
    assignin('base', 'Y', Y);
    assignin('base', 'T', T);
    assignin('base', 'TY', TY);
    
    %% LEARNING THE GLOBAL PLSR ON THE OVERALL TRAINING SET
    [kXL,kYL,kXS,kYS,BETAS_GLOBAL] = plsregress( X, Y, 30 );
    
    %% SPLITING TRAINING SET INTO SECTIONS DEFINED ABOVE
    % IN WAY TO LEARN SPECIFICS REGRESSORS ON THEM
    S = split(X, Y, sections);
    for i = 1 : size(S,1)
        LOCAL_X = S{i, 3};
        LOCAL_Y = S{i, 4};
        [kXL,kYL,kXS,kYS,BETAS_LOCAL] = plsregress( LOCAL_X, LOCAL_Y, 30 );
        S{i,5} = BETAS_LOCAL;
    end
    assignin('base', 'S', S);
 
    %% DOING A PREDICTION BASED ON THE GLOBAL REGRESSOR
    reg_overall = regress(T, BETAS_GLOBAL);
    
    %% SORTING reg IN SECTIONS DEFINED ABOVE
    %%%%%%%% on fait des groupes de features sur lequel on
    %%%%%%%% appliquera les regresseurs locaux
    
    %% USING LOCAL REGRESSOR ON SECTIONS
    % on parcourt les tranches, et on utilise regress()
    profile viewer
    return; % On reste sur le premier testing set
end
 

end



