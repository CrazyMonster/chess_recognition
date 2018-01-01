id = 1;
ds = load_dataset(id);

labels = ds.Labels;

% creazione dei dati

features = zeros(size(labels, 1), 2);
vector = repmat('*', size(labels, 1), 1);

counter = 1;

for i = 1:size(labels, 1)
    l = labels(i, :);
    
    board = parse_fen(l.BoardConfiguration);
    for j = 1:8
        for k = 1:8
            
            im = imread(['datasets/' num2str(id) '/tmp/cells/' char(l.Image) '/' num2str(j) 'x' num2str(k) '.jpg']);
            features(counter, :) = compute_mean_stdev(im);
            vector(counter) =  board(j, k);
            
            counter = counter + 1;
        end
    end
end

% partizionamento del dataset

cv = cvpartition(vector, 'HoldOut', 0.2);

train.features = features(cv.training);
train.labels = vector(cv.training);

test.features = features(cv.test);
test.labels = vector(cv.test);

% training

classifier = fitcknn(train.features, train.labels);
predicted_train = predict(classifier, train.features);
cm_train = confmat(train.labels, predicted_train);

predicted_test = predict(classifier, test.features);
cm_test = confmat(test.labels, predicted_test);
