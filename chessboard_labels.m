id = 3;
ds = load_dataset(id);

labels = ds.Labels;

% creazione dei dati

features2 = zeros(size(labels, 1), 61);
vector2 = repmat('*', size(labels, 1), 1);

 % lbp = []; % Local binary pattern histograms
 glcm2 = []; % Gray-Level Co-Occurence Matrices
 ghist2 = []; % Gray-level histograms
  
counter = 1;

for i = 1:size(labels, 1)
    l = labels(i, :);
    
    board = parse_fen(l.BoardConfiguration);
    for j = 1:8
        for k = 1:8
            
           % im = imread(['datasets/' num2str(id) '/tmp/cells/' char(l.Image) '/' num2str(j) 'x' num2str(k) '.jpg']);
             im = imread(['datasets/' num2str(id) '/tmp/cells/' char(l.Image) '/morphological/1/' num2str(j) 'x' num2str(k) 'out2.jpg']);
%           
%            features(counter, :) = classification.compute_(im);
%            features(counter, :) = classification.compute_mean_stdev(im);
             

features2(counter, :) = [classification.compute_mean_stdev(im), double(classification.compute_lbp(im))];
%               lbp = [lbp; classification.compute_lbp(im)];
%               lbp = double(lbp);
              glcm2 = [glcm2; classification.compute_glcm(im)];
              ghist2 = [ghist2; classification.compute_ghist(im)];
              vector2(counter) =  board(j, k);

            counter = counter + 1;
        end
    end
end

% featuresA = [features; T.Features];
% vectorA = [vector; vector2];
% 
% GLCM2 = [glcm; glcm2];
% GHIST2 = [ghist; ghist2];

T3 = table;

T3.Features = features2;
T3.GHist = ghist2;
T3.GLCM = glcm2;
T3.Labels = vector2;

T3e = T3(T3.Labels~='*', :);

T123 = table;
T123 = [T; T3];
T123p = [T2; T3e];


%%
% addestramento solo sulle celle non vuote

non_empty = (vector ~= '*');

features = features(non_empty);
% lbp = lbp(non_empty);
% glcm = glcm(non_empty);
% ghist = ghist(non_empty);
vector = vector(non_empty);

% partizionamento del dataset

cv = cvpartition(vector, 'HoldOut', 0.2);

%
train.features = features(cv.training);
train.labels = vector(cv.training);

% train.lbp = lbp(cv.training, :);
% train.ghist = ghist(cv.training, :);
% train.glcm = glcm(cv.training, :);

%
test.features = features(cv.test);
test.labels = vector(cv.test);

% test.lbp = lbp(cv.test, :);
% test.ghist = ghist(cv.test, :);
% test.glcm = glcm(cv.test, :);

%%
% training 1 features

classifier_cart_f = fitctree(train.features, train.labels);
predicted_train = predict(classifier_cart_f, train.features);
cm_train_1 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_cart_f, test.features);
cm_test_1 = confmat(test.labels, predicted_test);

%%
% training 2 features

classifier_knn_f = fitcknn(train.features, train.labels);
predicted_train = predict(classifier_knn_f, train.features);
cm_train_2 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_knn_f, test.features);
cm_test_2 = confmat(test.labels, predicted_test);

%% 
% training 3 features

classifier_bayes_f = fitcnb(train.features, train.labels);
predicted_train = predict(classifier_bayes_f, train.features);
cm_train_3 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_bayes_f, test.features);
cm_test_3 = confmat(test.labels, predicted_test);

%%
% training 1 lbp

classifier_cart_l = fitctree(train.lbp, train.labels);
predicted_train = predict(classifier_cart_l, train.lbp);
cm_train_4 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_cart_l, test.lbp);
cm_test_4 = confmat(test.labels, predicted_test);

%%
% training 2 lbp

classifier_knn_l = fitcknn(train.lbp, train.labels);
predicted_train = predict(classifier_knn_l, train.lbp);
cm_train_5 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_knn_l, test.lbp);
cm_test_5 = confmat(test.labels, predicted_test);

%% 
% training 3 lbp

classifier_bayes_l = fitcnb(train.lbp, train.labels);
predicted_train = predict(classifier_bayes_l, train.lbp);
cm_train_6 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_bayes_l, test.lbp);
cm_test_6 = confmat(test.labels, predicted_test);

%%
% training 1 ghist

classifier_cart_ghist = fitctree(train.ghist, train.labels);
predicted_train = predict(classifier_cart_ghist, train.ghist);
cm_train_7 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_cart_ghist, test.ghist);
cm_test_7 = confmat(test.labels, predicted_test);

%%
% training 2 ghist

classifier_knn_ghist = fitcknn(train.ghist, train.labels);
predicted_train = predict(classifier_knn_ghist, train.ghist);
cm_train_8 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_knn_ghist, test.ghist);
cm_test_8 = confmat(test.labels, predicted_test);

%% 
% training 3 ghist

% classifier_bayes_ghist = fitcnb(train.ghist, train.labels);
% predicted_train = predict(classifier_bayes_ghist, train.ghist);
% cm_train_9 = confmat(train.labels, predicted_train);
% 
% predicted_test = predict(classifier_bayes_ghist, test.ghist);
% cm_test_9 = confmat(test.labels, predicted_test);
%%
% training 1 glcm

classifier_cart_glcm = fitctree(train.glcm, train.labels);
predicted_train = predict(classifier_cart_glcm, train.glcm);
cm_train_10 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_cart_glcm, test.glcm);
cm_test_10 = confmat(test.labels, predicted_test);

%%
% training 2 glcm

classifier_knn_glcm = fitcknn(train.glcm, train.labels);
predicted_train = predict(classifier_knn_glcm, train.glcm);
cm_train_11 = confmat(train.labels, predicted_train);

predicted_test = predict(classifier_knn_glcm, test.glcm);
cm_test_11 = confmat(test.labels, predicted_test);

%% 
% training 3 glcm
% 
% classifier_bayes_glcm = fitcnb(train.glcm, train.labels);
% predicted_train = predict(classifier_bayes_glcm, train.glcm);
% cm_train_12 = confmat(train.labels, predicted_train);
% 
% predicted_test = predict(classifier_bayes_glcm, test.glcm);
% cm_test_12 = confmat(test.labels, predicted_test);