function sections = split(database, section)
%SPLIT_SECTION Summary of this function goes here
%   Detailed explanation goes here
    % Example
    % section = [20 30 40 50 60 70]
    % section = [50]; % split in 2 groups, less than 50 and more
    
    
    [r, c] = size(section);

    % On crée les groupes
    sections = cell(c, 3);
    for i = 1 : c+1
        sections{i, 1} = [];
        
        if i == 1
           sections{i, 2} = 0;
           sections{i, 3} = section(i);
           
        elseif i <= c
            
           sections{i, 2} = section(i - 1) + 1;
           sections{i, 3} = section(i);
           
        else
            sections{i, 2} = section(i - 1) + 1;
            sections{i, 3} = 100;
        end
    end
    
    % On parcourt la base
    for i = 1:length(database)
        
        age = str2num(database{i}.age);
        
        % Pour chaque individu on le met dans la bonne tranche
        for j = 1:c+1
           
            mini = sections{j, 2};
            maxi = sections{j, 3};
            
            if age >= mini && age <= maxi
                face = cell(1);
                face{1} = struct(database{i});
                sections{j, 1} = vertcat(sections{j,1}, face);
            end
            
        end
    end
    
    save('mat/sections/s', 'sections');
    
    
    % On eclate les sections en autant de fichier que de section
    %{
    for i = 1:c+1
        
        % On crée des variables s_1, s_2, s_3 etc... autant que de sections
        eval(sprintf('s_%d = sections{%d, 1};', i, i));
      
        filename = strcat('mat/sections/s_', num2str(i));
        
        % on save s_1, s_2, s_3, etc...
        save(filename, sprintf('s_%d', i));
        
    end
    %}
end

