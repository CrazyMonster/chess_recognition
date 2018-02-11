id = 3;
ds = load_dataset(id);
labels = ds.Labels;

% creazione dei dati
mean = zeros(height(labels), 8 , 8, 1);
stdev = zeros(height(labels), 8 , 8, 1);
lbp = zeros(height(labels), 8 , 8, 59);
hog = zeros(height(labels), 8 , 8, 144);
glcm = zeros(height(labels), 8 , 8, 64);
projectionX = zeros(height(labels), 8 , 8, 64);
projectionY = zeros(height(labels), 8 , 8, 64);

% response vector
vector = repmat('*', height(labels), 8, 8, 1);

parfor i = 1:size(labels, 1)
    l = labels(i, :);
    
    board = parse_fen(l.BoardConfiguration);
    for j = 1:8
        for k = 1:8
            
            im = imread(['datasets/' num2str(id) '/tmp/cells/' char(l.Image) '/' num2str(j) 'x' num2str(k) '.jpg']);
            
            mean(i, j, k, :) = classification.compute_mean(im);
            stdev(i, j, k, :) = classification.compute_stdev(im);
            lbp(i, j, k, :) = classification.compute_lbp(im);
            
            hog(i, j, k, :) = extractHOGFeatures(im, 'CellSize', [16 16], 'BlockOverlap', [0 0]);
            glcm(i, j, k, :) = classification.compute_glcm(im);
            projectionX(i, j, k, :) = sum(im, 1);
            projectionY(i, j, k, :) = sum(im, 2);
            
            vector(i, j, k) = board(j, k);
        end
    end
end

% creo la tabella
T3 = table;

% aggiungo le colonne per le features
T3.Mean = reshape(mean, [], 1);
T3.Stdev = reshape(stdev, [], 1);
T3.LBP = reshape(lbp, [], 59);
T3.HOG = reshape(hog, [], 144);
T3.glcm = reshape(glcm, [], 64);
T3.ProjectionX = reshape(projectionX, [], 64);
T3.ProjectionY = reshape(projectionY, [], 64);


T3.Labels = reshape(vector, [], 1);

%%
T = [T1; T2; T3];