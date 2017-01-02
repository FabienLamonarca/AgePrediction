function folders = CVFolders_age_split(database)

k1_0_22 = [];
k2_23_36 = [];
k3_37_67= [];
k4_68_more = [];


 
for i = 1:length(database)

    age = str2num(database{i}.age);
    
    if age < 23
        disp(['La variable age pour la boucle 1 vaut : ' num2str(database{i}.age)]);
        k1_0_22 =[k1_0_22,database{i}];
    elseif age < 37
        disp(['La variable age pour la boucle 2 vaut : ' num2str(database{i}.age)]);
        k2_23_36 = [k2_23_36, database{i}];
        
    elseif age <68
        disp(['La variable age pour la boucle 3 vaut : ' num2str(database{i}.age)]);
        k3_37_67 = [k3_37_67, database{i}];
        
    elseif age > 67
        disp(['La variable age pour la boucle 4 vaut : ' num2str(database{i}.age)]);
        k4_68_more = [k4_68_more, database{i}];
        
    end
end

folders = { k1_0_22, k2_23_36, k3_37_67, k4_68_more};

save( 'mat/k1_0_22.mat', 'k1_0_22' );
save( 'mat/k2_23_36.mat', 'k2_23_36' );
save( 'mat/k3_37_67.mat', 'k3_37_67' );
save( 'mat/k4_68_more.mat', 'k4_68_more' );




