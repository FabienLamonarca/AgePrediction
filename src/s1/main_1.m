function mae = main_1(database, feature, section)

% Objectives of this file is to practice two learning.

% A first draft prediction called Y based on overall database

% A second prediction called Y2 based on sections of database
% containing ages closers of the prediction Y

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic 

% Folds generations
k = CVFolders(database);

% First learning Y
[MAE, kAE, reg] = crossValidatedRegression(database, feature, 'age', 30, k);
MAE


% Age affectation on base
ages = cell(size(database, 1), 1);

for i = 1 :  size(k, 2)
   ki = k{1, i};
   ri = reg{1, i};
   
   for j = 1 : size(ki, 2);
       id = ki(j);
       age = ri(j);
       ages{id, 1} = round(age);
   end
end

% Section generation for learning Y2
% section = [22 36 68];
sections = split(database, ages, section);

% Second learning Y2
MAE2 = [];
for i = 1 : size(sections, 1)
    db = sections{i,1};
    k2 = CVFolders(db);
    
    [MAEx, kAEx, regx] = crossValidatedRegression(db, feature, 'age', 30, k2);
    sections{i, 4} = MAEx;
    MAE2 = [MAE2 MAEx];
end

Mean_MAE2 = mean(MAE2)


% Exporting variables to workspace for exploration
%assignin('base','ages',ages);
%assignin('base','k',k);
assignin('base','reg',reg);
%assignin('base','MAE2', MAE2);
assignin('base','sections',sections);

toc
end

