function s = split(X, Y, sections)
%SPLIT_SECTION Summary of this function goes here
    % ex :
    %   X = features
    %   Y = ages
    %   sections = [20 50 70]    
    
    nbSections = size(sections, 2);
    nbData = size(Y,1);
    s = cell(nbSections, 5);    

    %% SECTIONS INIT
    for i = 1 : nbSections+1
        s{i, 3} = [];
        s{i, 4} = [];
        s{i, 5} = 'BETAS';
        
        if i == 1
           s{i, 1} = 0;
           s{i, 2} = sections(i);
           
        elseif i <= nbSections
            
           s{i, 1} = sections(i - 1) + 1;
           s{i, 2} = sections(i);
           
        else
            s{i, 1} = sections(i - 1) + 1;
            s{i, 2} = 100;
        end
    end
      
    %% Features / labels ASSIGNATION
    for i = 1 : nbData
        
        feature = X(i, :);
        age = Y(i);
        
        % Pour chaque individu on le met dans la bonne tranche
        for j = 1 : nbSections+1
           
            mini = s{j, 1};
            maxi = s{j, 2};
            
            if age >= mini && age <= maxi
                s{j, 3} = vertcat(s{j,3}, feature);
                s{j, 4} = vertcat(s{j,4}, age);
            end
            
        end
    end
    %assignin('base', 'S', s);
end

