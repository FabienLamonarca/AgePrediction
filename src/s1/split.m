function sections = split_section(database, ages, section)
%SPLIT Summary of this function goes here
%   Detailed explanation goes here

[r, c] = size(section);

% On crée les groupes
sections = cell(c, 4);
for i = 1 : c+1
    sections{i, 1} = [];
    if i == 1
       sections{i, 2} = -1000;
       sections{i, 3} = section(i);
    elseif i <= c
       sections{i, 2} = section(i - 1) + 1;
       sections{i, 3} = section(i);
    else
        sections{i, 2} = section(i - 1) + 1;
        sections{i, 3} = 1000;
    end
end
    
% On parcourt la base
for i = 1:length(database)

    age = ages{i, 1};

    % Pour chaque individu on le met dans la bonne tranche
    for j = 1:c+1

        mini = sections{j, 2};
        maxi = sections{j, 3};

        if age >= mini && age <= maxi
            face = cell(1);
            face{1, 1} = database{i, 1};
            %face{1, 2} = ages{i, 1};
            sections{j} = vertcat(sections{j}, face);
        end

    end
end

save('mat/sections/s', 'sections');

end

