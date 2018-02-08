id = 1;
ds = load_dataset(id);

labels = ds.Labels;

MeanSTDev = zeros(height(labels), 8, 8, 4, 2);
HOG = zeros(height(labels), 8, 8, 4, 24);
Orientation = repmat(char(0), height(labels), 8, 8, 4, 2);

for i = 1:size(labels, 1)
    l = labels(i, :);
    
    board = parse_fen(l.BoardConfiguration);
    
    for j = 1:8
        for k = 1:8
            
            path = (['datasets/' num2str(id) '/tmp/cells/' char(l.Image) '/' num2str(j) 'x' num2str(k) '.jpg']);
            im = imread(path);
            
            for o = 1:4
                orientation = dec2bin(o - 1, 2);
                
                if board(j, k) == '*'
                    orientation(1) = '*';
                    
                    if mod(j + k, 2) == 0
                        orientation(2) = '*';
                    end
                end
                
                MeanSTDev(i, j, k, o, :) = classification.compute_mean_stdev(im);
                %HOG(i, j, k, o, :) = extractHOGFeatures(im, 'CellSize', [16 16], 'BlockOverlap', [0 0]);
                HOG(i, j, k, o, :) = extractHOGFeatures(im, 'CellSize', [32 32], 'NumBins', 6, 'BlockOverlap', [0 0]);
                Orientation(i, j, k, o, :) = orientation;
                
                im = rot90(im, -1);
            end
        end
    end
end

T1 = table;

MeanSTDev = reshape(MeanSTDev, [], 2);
T1.Mean = MeanSTDev(:, 1);
T1.STDev = MeanSTDev(:, 2);
T1.HOG = reshape(HOG, [], 24);
T1.Orientation = reshape(Orientation, [], 2);

