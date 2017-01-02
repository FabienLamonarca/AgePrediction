load('pal_crop2.mat');
k = CVFolders(faces);

crossValidatedRegression( faces, 'vgg_face_features_fc7', 'age', 30, k );  