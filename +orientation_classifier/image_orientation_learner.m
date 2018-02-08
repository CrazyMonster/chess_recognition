id = 1;
ds = load_dataset(id);

labels = ds.Labels;

Image = strings(height(labels), 4, 64);
Orient = zeros(height(labels), 4, 64);
Cell = zeros(height(labels), 4, 64, 2);
Mean = zeros(height(labels), 4, 64);
Std = zeros(height(labels), 4, 64);
HOG = zeros(height(labels), 4, 64, 24);
Orientation = repmat(char(0), height(labels), 4, 64, 2);

parfor i = 1:size(labels, 1)
    l = labels(i, :);
    
    path = (['datasets/' num2str(id) '/tmp/eq/' char(l.Image) '.jpg']);
    
    im = imread(path);
    im = im(9:520, 9:520);
    
    board = parse_fen(l.BoardConfiguration);
    
    is_empty = (board == '*');
    is_white = (mod((1:8) + (1:8)', 2) == 0);

    X = repmat((1:8)', 1, 8);
    Y = repmat((1:8), 8, 1);
    
    for o = 1:4
        cols = im2col(double(im), [64 64], 'distinct');
        mu = mean(cols);
        sigma = std(cols);
        
        hog = extractHOGFeatures(im, 'CellSize', [32 32], 'NumBins', 6, 'BlockSize', [2 2], 'BlockOverlap', [0 0]);
        
        orientation = repmat(dec2bin(o - 1, 2), 64, 1);
        orientation(is_empty, 1) = '*';
        orientation(is_empty & is_white, 2) = '*';
        
        Image(i, o, :) = l.Image;
        Orient(i, o, :) = o;
        
        c = [];
        c(:, 1) = X(:);
        c(:, 2) = Y(:);
        
        Cell(i, o, :, :) = c;
        
        Mean(i, o, :) = mu;
        Std(i, o, :) = sigma;
        HOG(i, o, :, :) = reshape(hog, 24, 64)';
        
        Orientation(i, o, :, :) = orientation;

        im = rot90(im, -1);
        is_empty = rot90(is_empty, -1);
        is_white = rot90(is_white, -1);
        
        X = rot90(X, -1);
        Y = rot90(Y, -1);
    end
end

T1 = table;
T1.Image = Image(:);
T1.Orient = Orient(:);
T1.Cell = reshape(Cell, [], 2);
T1.Mean = Mean(:);
T1.Std = Std(:);
T1.HOG = reshape(HOG, [], 24);
T1.Orientation = reshape(Orientation, [], 2);
