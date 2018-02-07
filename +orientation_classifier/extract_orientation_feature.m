function out = extract_orientation_feature(image)

    image = image + 1;
    id = 3;
    ds = load_dataset(id);
    
    labels = ds.Labels;
    
    MeanSTDev = zeros(height(labels), 8, 8, 4, 2);
    HOG = zeros(height(labels), 8, 8, 4, 1764);
    Orientation = repmat(char(0), height(labels), 8, 8, 4, 2);
    
    parfor i = 1:size(labels, 1)
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
                    HOG(i, j, k, o, :) = extractHOGFeatures(im);
                    Orientation(i, j, k, o, :) = orientation;
                    
                    im = rot90(im, -1);
                end
            end
        end
    end
    
    T3 = table;
    T3.MeanSTDev = reshape(MeanSTDev, height(labels) * 8 * 8 * 4, 2);
    T3.HOG = reshape(HOG, height(labels) * 8 * 8 * 4, 1764);
    T3.Orientation = reshape(Orientation, height(labels) * 8 * 8 * 4, 2);
end 
