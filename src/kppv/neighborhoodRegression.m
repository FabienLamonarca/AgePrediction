% neighborhoodRegression(faces, 'LBP', 'age', 30, {k1, k2, k3, k4, k5}, 20);

function [ MAE, kAE ] = neighborhoodRegression( data, featureName, targetName, NCOMP, kFolds, neighborNumber )
tic
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % FEATURE NORMALIZATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    assignin('base', 'kX', kX);
    
    for i = 1:numFolds % Pour chaque fold
        fold = kX{i,1};
        
        for j = 1:size(fold,2) % On parcourt les colones du fold
            x_min = min(fold(:,j));
            x_max = max(fold(:,j));
            if x_min ~= x_max
                % On parcourt les individus pour les normaliser
                for l = 1:size(fold,1)
                    xi = kX{i,1}(l,j);
                    kX{i,1}(l,j) = (xi - x_min)/(x_max - x_min);
                end
            end
        end
    end
    assignin('base', 'kX_normalized', kX);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % CROSS VALIDATION      %
    %%%%%%%%%%%%%%%%%%%%%%%%%        
    % On parcourt chaque ensemble de test
    reg = [];
    for kk = 1:numFolds
        X = [];
        Y = [];
        T = []; % Test
        TY = []; % Test label
        
        % On crée les ensemble de training(X,Y) & test(T)
        for jj = 1:numFolds    
            if jj ~= kk
                X = vertcat( X, kX{ jj } );
                Y = vertcat( Y, kY{ jj } );
            elseif jj == kk
                T = kX{jj};
                TY = kY{jj};
            end
        end
        
        % Pour chaque element de test
        % On cherche ses 'neighborNumber' voisins
        % Et on fait un PLSR dessus
        for ti = 1:size(T)
           % X = training set
           % T = Test set
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
    
    toc
    %assignin('base', 'reg', reg);
end

