id = 1;
ds = load_dataset(id);
labels = ds.Labels;

% creazione dei dati
features = zeros(height(labels), 8 , 8, 2);
hog = zeros(height(labels), 8 , 8, 1764);

vector = repmat('*', height(labels), 8, 8, 1);

parfor i = 1:size(labels, 1)
    l = labels(i, :);
    
    board = parse_fen(l.BoardConfiguration);
    for j = 1:8
        for k = 1:8
            
            % im = imread(['datasets/' num2str(id) '/tmp/cells/' char(l.Image) '/' num2str(j) 'x' num2str(k) '.jpg']);
            im = imread(['datasets/' num2str(id) '/tmp/cells/' char(l.Image) '/morphological/1/' num2str(j) 'x' num2str(k) 'out2.jpg']);
            
            features(i, j, k, :) = [classification.compute_mean_stdev(im)];
            hog(i, j, k, :) = extractHOGFeatures(im);
            vector(i, j, k) = board(j, k);
        end
    end
end

% creo la tabella
T1  = table;

% aggiungo le colonne per le features
T1.Features = reshape(features, [], 2);
T1.HOG = reshape(hog, [], 1764);
T1.Labels = reshape(vector, [], 1);

%%
T = [T1; T2; T3];