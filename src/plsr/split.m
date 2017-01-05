function s = split(X, Y, sections, REAL_Y)
%SPLIT_SECTION Summary of this function goes here
    % ex :
    %   X = features
    %   Y = ages used for split
    %   sections = [20 50 70]    
    %   REAL_Y = Real age of person
    
    nbSections = size(sections, 2);
    nbData = size(Y,1);
    s = cell(nbSections, 5);    


    %% SECTIONS INIT
    for i = 1 : nbSections+1
        s{i, 3} = [];
        s{i, 4} = [];
        s{i, 5} = 'BETAS';
        s{i, 6} = [];
        
        if i == 1
           s{i, 1} = -1000;
           s{i, 2} = sections(i);
           
        elseif i <= nbSections
            
           s{i, 1} = sections(i - 1) + 1;
           s{i, 2} = sections(i);
           
        else
            s{i, 1} = sections(i - 1) + 1;
            s{i, 2} = 1000;
        end
    end
      
    %% Features / labels ASSIGNATION
    for i = 1 : nbData
        
        feature = X(i, :);
        age = Y(i);
        
        if  exist('REAL_Y')
            RY = REAL_Y(i,1);
        else
            RY = '';
        end
        
        % Pour chaque individu on le met dans la bonne tranche
        for j = 1 : nbSections+1
           
            mini = s{j, 1};
            maxi = s{j, 2};
            
            if age >= mini && age <= maxi
                s{j, 3} = vertcat(s{j,3}, feature);
                s{j, 4} = vertcat(s{j,4}, age);
                s{j, 6} = vertcat(s{j, 6}, RY);
            end
            
        end
    end
    %assignin('base', 'S', s);
    
end

