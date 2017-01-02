% clear all;
% close all;

% Ce fichier permet de classer les individus en 5 groupes
% Le seul critère etant de classer les individus concernants la même
% personne (meme ID) dans un même groupe. 

%load('morph_aligned.mat');

function folders = CVFolders(database)

k1 = [];
k2 = [];
k3 = [];
k4 = [];
k5 = [];

% Tableau vide de la taille de la base de données
ids = cell(length(database), 1);

% On parcourt la bdd, on rempli le tableau ids par les ID de la bdd
for i = 1:length(database)
    ids{i} = database{i}.id;
end

% On retire les ID doublons
uniqueIds = unique(ids);


% On parcourt les ID disctincte 
for i = 1:length(uniqueIds)
    i;
    % isequal(A, B) verifie si A et B sont égaux
    
    % @(x) -> function_handle with value @(x) isequal( x.id, uniqueIds{i} )
    
    % cellfun -> Apply function to each cell in cell array
    % cellfun(func, C1,...,Cn)
    % cellfun(func, array)
    
    % find -> retourne les indices des éléments non null (on compte
    % colone par colone de haut en bas
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Pour chaque cellule de 'faces', on verifie si l'id de la cellule est 
    % égal à uniqueIds{i} (l'élement que l'on parcourt) 
    
    % Handler de fonction
    handle_equals = @(x) isequal(x.id, uniqueIds{i});
    
    % Tableau de 0 et de 1 quand la cellule.id = uniqueIds{i}
    similar_id = cellfun(handle_equals , database); 
    
    % Tableau d'indice pour les ids similaires
    sameIds = find(similar_id);
    
    j = mod( i, 5 ); %  j = i%5     --- ok mais pourquoi ?
    
    % La cote a la fin sert a faire la transposé de sameIds
    % Car 'sameIds' peut être un vecteur de plusieurs lignes
    if j == 1
        k1 = [k1 sameIds']; % On ajoute la transposé de sameIds a la fin de k1   
    elseif j == 2
        k2 = [k2, sameIds']; % On ajoute la transposé de  sameIds a la fin de k2
    elseif j == 3
        k3 = [k3, sameIds']; % On ajoute la transposé de  sameIds a la fin de k3
    elseif j == 4
        k4 = [k4, sameIds']; % On ajoute la transposé de  sameIds a la fin de k4
    elseif j == 0
        k5 = [k5, sameIds']; % On ajoute la transposé de  sameIds a la fin de k5
    end   
end

folders = { k1, k2, k3, k4, k5 };

save( 'mat/k/k1.mat', 'k1' );
save( 'mat/k/k2.mat', 'k2' );
save( 'mat/k/k3.mat', 'k3' );
save( 'mat/k/k4.mat', 'k4' );
save( 'mat/k/k5.mat', 'k5' );



