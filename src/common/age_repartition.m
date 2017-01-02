% on verifie si on doit charger la base ou non.
if(exist('faces', 'var') == 0)
    load('pal_crop2.mat');
end

nb_images = size(faces,1);
ages = zeros(1, nb_images);

for i = 1 : nb_images
    image = faces(i, 1);
    struct = image{1,1};
    age = struct.age;
    age = str2num(age);
    ages(1, i) = (age);
end

h = histogram(ages);
h.FaceColor = 'green';
clear i image nb_images struct age;
